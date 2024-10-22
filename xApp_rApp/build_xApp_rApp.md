這裡是關於如何使用我們的 SDK 實作 xApp 的範例。

# 如何使用SDK？

## SDK 安裝

```bash
pip install AppAuthN
```

## **xApp來源註冊**

```python
import AppAuthN.CertificationReceiver as register

inference_api = <URL of Edge Server>
register.kongapi(inference_api)

register_data = {
    "application_uid": <application_uid>,
    "application_token": <application_token>,
    "position_uid": <position_uid>,
    "inference_client_name": <inference_client_name>,
}

register.send_register_request(register_data)
```

## 取得推論結果

```python
import AppAuthN.InferenceResult as inference
 
 raw_data = {
     "application_uid": <application_uid>,
     "position_uid": <position_uid>,
     "inference_client_name": <inference_client_name>,
     "value": <value>
 }
 
 inference.send_rawdata(raw_data)
```