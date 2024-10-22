# 我可以在哪裡獲取範本？

使用者可以訪問以下連結並檢查 **`django/<platform_version_tag>`** 分支。

平台版本標籤與部署平台版本相同。

[GitHub - mitlab-6g-team/inference_template_public: Inference host template for public use](https://github.com/mitlab-6g-team/inference_template_public)

# 如何實作推論功能？

當請求發送時，接收請求的function位於 **`main/apps/inference_exe/actors/InferenceServiceHandler`**，該部分處理從接收請求到回應的過程。使用者自定義的功能實作在 **`main/apps/inference_exe/actors/services/inference`**，我們稱之為服務函數。

服務函數中將包含兩個類別：Model 和 InferenceService。

對於 Model 類別，類別內的功能應組成模型需要提供的基本服務。

使用者必須根據不同的依賴和版本實作模型加載和預測功能，以使inference host正常運作。

```python
# main/apps/inference_exe/actors/services/inference
# Model Basic Functions
class Model():
    "Inference Functions"
    def __init__(self, model_path):
        "the function to load model."
        self.model = load_model(model_path)

    def inference(self, input_data):
        "the function to do inference."
        result = self.model.predict(input_data)
        return result

```

InferenceService 類別幫助使用者進行推論應用。我們已經為使用者規劃了基本功能，以完成推論過程。請在 `input_data_transform()` 中實作數據預處理或數據轉換過程。

```python
# main/apps/inference_exe/actors/services/inference
# Called by Main Functions
class InferenceService():
    model = None

    @staticmethod
    def load_model():
        if InferenceService.model is None:
            model_path = default_env.MODEL_SAVE_PATH + default_env.MODEL_FILE_NAME
            InferenceService.model = Model(model_path)
        return InferenceService.model

    @staticmethod
    def input_data_transform(input_data):
        #data processing here
        transformed_data = input_data
        return transformed_data

    @staticmethod
    def inference(input_data):
        try:
            transform_data = InferenceService.input_data_transform(input_data)
            inference_result = InferenceService.model.inference(transform_data)
            return {"status": "success", "value": str(inference_result.tolist())}

        except Exception as e:
            log_writer(log_level='ERROR', func=InferenceService.inference, message=str(e))
            return {"status": "error", "message": str(e)}
```

## 啟動 Django 伺服器時的自檢功能

當 Django 伺服器啟動時，`main/apps/inference_exe/apps.py` 中的 ready 函數將被執行。系統會在每次 Pod 啟動時自動運行 ready 函數。

```python
def ready(self):
        from .services.inference import InferenceService
        
        try: 
            model = InferenceService.load_model()
            ...
```

一旦健康檢查通過，系統將向部署平台發送成功消息，讓使用者了解監控中的 CPU 和記憶體使用率。

## 我的推論 API 的路徑是什麼？

為了將 API 路徑註冊到 Kubernetes 和 Kong Gateway，並自動從部署平台Dashboard建立推論服務，API 的 URL 必須是固定的，無論功能如何實作。

以 `main/apps/inference_exe/api/urls.py` 中的參數為例，

```python
from django.urls import path
from main.apps.inference_exe.actors import InferenceServiceHandler

# Don't change the path here
module_name = 'inference_exe'

urlpatterns = [
    path(f'{module_name}/InferenceServiceHandler/get_inference_result', InferenceServiceHandler.get_inference_result)
]
```

Inference template使用者只需關心如何利用我們開發的 SDK 進行推論。SDK 的介紹在 [**關於 xApp/rApp**](https://www.notion.so/xApp-rApp-61e66013c6c64f0988dccdbcdf742225?pvs=21) 、 [AI/ML平台-Mitlab xApp/rApp SDK (尚未啟用)](https://www.notion.so/AI-ML-Mitlab-xApp-rApp-SDK-106b65a4cedb8018bed1e87eda22bf49?pvs=21) 

# 不使用SDK的API文件

## 推論服務

此 API 允許讓使用者透過API取得模型推論結果

- API Endpoint
    
    ```
    POST http://<host_ip>:8000/inference-service-<position_uid>
    ```
    
- Request Header
    
    ```json
    {
    	"Content-Type": "application/json"
    }
    ```
    
- Request Body
    
    ```json
    // Required payload: 
    // value
    
    {
      "value": "any_type_of_raw_data"
    }
    ```
    
- Example CURL Request
    
    ```bash
    curl --request POST \
      --url http://<host_ip>:<backend_entrypoint>/api/inference_exe/InferenceServiceHandler/get_inference_result \
      --header 'Content-Type: application/json' \
      --data '{
      "value": "any_type_of_raw_data"
    }'
    ```
    
- Response

    - 200 OK
        
        ```json
        {
          "status": "success",
          "value": "<inferenc_result>"
        }
        ```
    - 400 ERROR
        ```json
        {
          "status": "error",
          "message": "Missing 'value' key in request data"
        }
        ```
    
        ```json
        {
          "status": "error",
          "message": "Invalid JSON in request body"
        }
        ```
    - 422 ERROR
        
        ```json
        {
          "status": "error",
          "message": "<message_from_model>"
        }
        ```
    - 500 ERROR
        ```json
        {
          "status": "error",
          "value": "An unexpected error occurred"
        }
        ```