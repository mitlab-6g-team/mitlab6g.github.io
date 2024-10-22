# Deployment Platform 部屬

這個指南幫助使用者設置部署平台。請從我們的 GitHub 存儲庫獲取安裝程式！

## 預設環境

部署流程會安裝一切所需套件

- Python 3.8
- Docker-ce 20.10.21

## 安裝包下載

```bash
git clone https://github.com/mitlab-6g-team/mitlab_deployment_platform.git
```

## 填入環境變數

- .env.common.sample
    - 當前系統最新版本對應請看下方表格
    - 規定
        - TRAINING_PF_HOST_IP
    - 自定義
        - DEPLOYMENT_PF_HOST_IP
        - EDGE_SERVER_HOST_IP
        - PORT
- .env.inference_config
    - 可選更動
- .env.postgres_config
    - 可選更動
- .env.pgadmin_config
    - 可選更動

### 系統版本

| 系統名稱 | 系統版本 | 是否有固定port |
| --- | --- | --- |
| AGENT_OPERATION | v1.1.5 | 34806 |
| METADATA_MGT | v1.1.1 | - |
| FILE_MGT | v1.1.1 | - |
| CENTRAL_CONNECTOR | v1.1.1 | - |
| INFERENCE_CONNECTOR | v1.1.2 | - |
| AUTHENTICATE_MIDDLEWARE | v1.1.1 | - |
| AGENT_USER_DASHBOARD | v1.1.2 | - |
| SYSTEM_TASK_MGT | v1.1.1 | 30303 |
| INFERENCE_TASK_MGT | v1.1.1 | 不需要 |
| DATAFLOW_MGT | v1.1.0 | 30308 |

## 開始安裝

```bash
cd mitlab_deployment_platform
bash ./install_all.sh
```

## **激活 mitlab_deployment_server**

- 填入所需資訊
    - 從 mitlab_deployment_server 資料夾內**的** .env.common.sample 取得
        - DEPLOYMENT_PF_HOST_IP
        - CENTRAL_CONNECTOR_CONTAINER_PORT
- 從 training platform 取得資訊
    - AGENT_UID
    - AGENT_ACTIVATION_TOKEN
- 實際激活
    
    ```bash
    curl --location 'http://<DEPLOYMENT_PF_HOST_IP>:<CENTRAL_CONNECTOR_CONTAINER_PORT>/api/v1.1.1/central_operation/AgentLifeManager/init' \
    --header 'Content-Type: application/json' \
    --data '{
    	"agent_uid": "<AGENT_UID>",
    	"agent_activation_token":"<AGENT_ACTIVATION_TOKEN>"
    }'
    ```

# Edge Server 部署

這個指南幫助使用者設置邊緣伺服器。請確保在本頁面上已安裝所有基本環境和依賴項。

## 預設環境

部署流程會安裝一切所需套件

- Python 3.8
- Docker-ce 20.10.21

## 安裝包下載

```bash
git clone https://github.com/mitlab-6g-team/mitlab_edge_server.git
```

## 填入環境變數

- .env.common.sample

## 開始安裝

```bash
cd mitlab_edge_server
bash ./install_all.sh
```