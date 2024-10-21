# mitlab6g.github.io
# 推論系統的架構

[link here](./deployment_platform.md) 

# 推論系統

推論系統是由兩個部分所組成，「部屬平台」以及「邊緣伺服器」，提供使用者模型於應用端的生命週期管理、快速的部屬自動化、以及簡易的模型訂閱機制，讓使用者僅需專注於模型效能的提升，無須額外思考業務邏輯的設計與API的開發。推論系統需搭配NTUST MITLab 所開發之訓練平台使用。

# 部屬平台（deployment platform）

部署平台的目標是將模型部署到邊緣伺服器上進行推理任務。通過這個過程，使用者可以從模型訓練後直接管理實際應用的整個模型生命週期，並降低部署的難度。部署平台還會從訓練平台訂閱模型的相關資訊。

![Platform Architecture](image.png)

Platform Architecture

## 抽象類別階層

無論是訓練平台還是部署平台，都是由抽象類別進行管理。透過這種層級結構，模型的生命週期和推理流程能夠有序進行。

![image.png](image%201.png)

### **Projects**

專案（Projects）是一個頂層的抽象類別，包含了組織中由專案經理管理的多個應用程式。

### **Applications**

應用（Applications）是專案中的一個抽象類別，用來區分不同的目標，例如同屬無人機專案之鐘的無人機路徑預測或無人機電池預測。你可以在相同應用程式內選擇表現最佳的模型。

### **Positions**

位置（Positions）是一個在部署平台上非常重要的類別。它相對於部署平台而言是相當獨立的，這意味著部署平台和邊緣伺服器可以分別建置在不同的虛擬機甚至不同的實體伺服器上。位置的特性讓使用者能夠將模型部署至靠近xApp所在位置的邊緣伺服器。

Positions的目標有下列幾點：

- 降低部屬時間
- 分類整個推論服務
- 監測推論任務的狀態與生命週期

**補充資訊**

位置（Position）既不是檔案也不是Process，而是一個由多個Process組成的推論服務。這些Process位於兩個空間中：Docker 空間和 Kubernetes 空間。位置內的組成部分包括：

1. Position Monitor
2. Inference Host
3. Kubernetes Service

![image.png](image%202.png)

**Position Monitor**

部署平台是使用者觸發監控和命令介面的地方。為了妥善管理位置，Position Monitor將成為使用者了解邊緣伺服器 CPU 和記憶體資源使用率的有用工具。此外，inference host在未來版本將具備擴展性。因此，Position Monitor負責每個Position的水平 Pod 自動擴展（HPA）以及inference host內的模型管理。

**Inference Host**

inference host是實際進行推理任務的地方。inference host由inference template和model 組成。使用者只需要使用我們的範本來實作功能，或者按照介面來建立自己的模板。詳細資訊請參閱頁面 [**Let's start to build an inference host! (未完成)**](https://www.notion.so/Let-s-start-to-build-an-inference-host-e0fca45d96eb4ad3b37c90d3239cda01?pvs=21) ！

**Kubernetes Service**

Pod 是 Kubernetes 叢集架構中的一種資源類別。一個 Pod 由一個或多個容器組成以形成微服務。當 Pod 啟用時，主節點會分配一個叢集 IP。儘管 Pod 可以動態部署到不同的工作節點，但叢集 IP 會頻繁變更，導致系統不穩定。因此，我們需要 Kubernetes 的服務來幫助我們透過標籤和選擇器將請求發送到特定的微服務。

此外，Kubernetes 提供了三種服務類型：NodePort、ClusterIP 和 LoadBalancer 模式。在我們的部署平台中，我們使用 LoadBalancer 模式來實現簡單的負載均衡功能。

# 邊緣伺服器（Edge Server）

邊緣伺服器是實際執行推理任務的地方。推理主機、Kubernetes 服務和位置監控（Position Monitor）這些位置（Position）的組成部分也包含在邊緣伺服器中。

以下展示了邊緣伺服器的架構。

![image.png](image%203.png)

除了位置（Position）之外，我們還設計了閘道系統來管理請求路徑。在設計 xApp 時，使用者只需專注於他們的功能。有了我們的 SDK，所有與請求 URL 相關的部分都會由 SDK 以及Kong Gateway 負責處理。

### **Kong Gateway**

Kong Gateway 是一個輕量級、快速且靈活的雲原生 API 閘道。API 閘道是一種反向代理，允許您管理、配置和路由請求到您的 API

reference: [https://docs.konghq.com/gateway/latest/](https://docs.konghq.com/gateway/latest/)