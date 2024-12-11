<div class="container-fluid main-container">


<div class="row">


<div class="toc-content col-xs-12 col-sm-8 col-md-9">


<div id="header">


# MacBehaviour: Conduct Psychological Experiments on LLMs

</div>
<img width="837" alt="image" src="https://github.com/user-attachments/assets/93b6c073-ca3e-4821-961a-c552b977e6d0">




<br><br>
The `MacBehaviour`(short for Machine Behaviour) R package offers a user-friendly toolkit for conducting  psychological experiments on over 100 Large langauge models(LLMs) in a few lines.

**Since Hugging Face offers free inference services for certain models, you can begin experimenting with this package via [Demo Code - HuggingFace](#demo-code---hugging-face).**

For details and citation, please see the preprint: <a href="https://arxiv.org/abs/2405.07495"> Duan, X., Li, S., & Cai, Z. G. (2024). MacBehaviour: An R package for behavioural experimentation on large language models. </a>

Please pilot test your experiment before running it, as we are not responsible for any potential losses incurred.

<div id="installing-and-loading-necessary-packages" class="section level3">
  
  
## News

2024-Oct-16: Package paper accepted by Behavior Research Methods.<br>
2024-Sep-5: Support logging Logprobs for Chat models on Hugging Face via Message API.<br>
2024-July-2: Support models on Qianfan Baidu.<br>

## Table of Contents
- [Supported Model Platforms](#supported-model-platforms)
- [Supported Models](#supported-models)
- [Note](#note)
- [Frequently Asked Questions](#Frequently-Asked-Questions)
- ⭐️[Installation](#installation)
- ⭐️[Demo Code - HuggingFace](#demo-code---hugging-face)
- ⭐️[Demo Code - OpenAI](#demo-code---openai)
- ⭐️[Demo Code - Qianfan Baidu](#Demo-Code---Qianfan-Baidu)
- [Tutorial](#tutorial)
  - [1. Communicate with Models](#1-communicate-with-models)
  - [2. Experiment Design](#2-experiment-design)
  - [3. Demo Experiments](#3-demo-experiments)
  - [4. Result Structure](#4-result-structure)


## Supported Model Platforms

This package enables local deployment of LLMs through **FastChat** (https://github.com/lm-sys/FastChat).

If you prefer using cloud-based models, this package currently supports the following platforms:

1. [OpenAI](https://platform.openai.com/)
2. [Hugging Face](https://huggingface.co/)
3. [Claude](https://www.anthropic.com/api)
4. [Gemini](https://ai.google.dev/)
5. [Qianfan Baidu](https://qianfan.cloud.baidu.com/)
6. [Baichuan](https://platform.baichuan-ai.com/)
7. [AI/ML](https://aimlapi.com/)

## Supported Models

| Model                                                     | Developer/Platform                |
| :-------------------------------------------------------- | --------------------------------- |
| GPT  family  (GPT-3.5,  GPT-4 et al.)                     | OpenAI (OpenAI et al., 2024)      |
| Claude family  (Haiku, Sonnet, Opu et al.)                | Anthropic (Anthropic,  2023)      |
| Gemini family  (Ultra, Pro, and Nano et al.)              | Google (Gemini Team et al., 2023) |
| Llama  family  (Llama-2,  Llama-3)                        | Meta  (Touvron et al., 2023)      |
| BaiChuan family  (7B, 13B et al)                          | Baichuan (Yang et al., 2023)      |
| 50+  other self-hosted LLMs  (e.g.,  Vicuna, FastChat-T5) | FastChat (Zheng  et al., 2023)    |
| 200+ other cloud-hosted LLMs	                            | AI/ML API (AI/ML API, 2024)       |

## Frequently Asked Questions
`Q1: How to convert log-probabilities to probabilities in both R and Excel`<br>
To convert log probability (logp) to regular probability (p) in both R and Excel, you can use the exponential function. <br>
In R:
```R
p <- exp(logp)
```
In Excel:
```Excel
# Assuming your log probability is in cell A1, you can use the EXP function to convert it:
=EXP(A1)
```
This will give you the probability corresponding to the log probability value.<br>

`Q2: Why are there duplicate trial numbers within a session?` <br>
A: Please check if the item_id is duplicated. <br>
<br>

`Q3: Why does Error 422 occur?`  <br>
A: The model has context limits. <br>For example, Llama-3.2-Instruct is limited to 4096 tokens, so the prompt length (including conversation history across multiple trials per run design) must stay within that limit. <br>You can consider to spilt the items into several lists to avoid this error or simply use one trial per run desgin for now.<br> 
<br>

## Note
对于在中国内地的研究者，如果使用代理，请在脚本中添加
```R
Sys.setenv(https_proxy = "http://127.0.0.1:XXXX")
```
其中XXXX为代理端口号，了解 <a href = "https://github.com/xufengduan/MacBehaviour/blob/main/Materials/proxy_issue.md">如何获得端口号</a>。<br>

由于地区限制可能无法使用 OpenAI 和 Hugging Face的，可以查看 [Demo Code - Qianfan Baidu](#Demo-Code---Qianfan-Baidu)。千帆平台除了文心模型以外，还支持一些开源模型，并且提供免费的api调用。但需要提前一天注册，才能使用免费模型。<br><br>




## Installation

There are two ways for installing this package: from Github or CRAN

```R
# From github
install.packages("devtools")
devtools::install_github("xufengduan/MacBehaviour", upgrade = "never")

```

<div id="set-api-key" class="section level3">
Or you can install the package from CRAN by

```R
# From CRAN
# install.packages("MacBehaviour")
```


Upon the successful installation, users can load this package into the current R session:

``` R
library("MacBehaviour")
```
## Demo Code - Hugging Face

We have provided two demonstration scripts for you to try: one for models hosted on Hugging Face and another for models from OpenAI.

**Since Hugging Face offers free inference services for certain models, we recommend starting your experimentation with Hugging Face before using OpenAI.**

If you want to learn more about this package, please refer to the detailed [tutorial](#tutorial).

1. Install and load the package. You can skip it if you have already done it.
```R
install.packages("devtools")
devtools::install_github("xufengduan/MacBehaviour", upgrade = "never")
library("MacBehaviour")
```
2. Deploy a model on HuggingFace. Click the <a href="https://huggingface.co/"> link </a> here and sign up for a HuggingFace account.
![image01](https://github.com/user-attachments/assets/477f6c10-4f2d-47d0-bbae-c91f4d04c9e7)
<br><br>
Note that you will receive an email in which you will need to click on the confirmation link to verify your account.
![image02](https://github.com/user-attachments/assets/03b37a2d-3a73-4f04-8d6f-65c5a78423e6)
<br><br>
3. Deploy inference endpoints. We will use the model <a href="https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct"> meta-llama/Llama-3.2-3B-Instruct </a> (just for example). You can choose other LLMs as you wish.
![image03](https://github.com/user-attachments/assets/c244a312-4959-473c-a848-ce3aa35c5318)
<br><br>
4. Create endpoint. You need to bind a credit card to your account to use the model deployment service on HuggingFace. Select the corresponding options according to your needs. The estimated cost is shown in the bottom right corner. If you select ‘Never automatically scale to zero’, remember to pause the model when you are not using it or it will keep charging.
![image04](https://github.com/user-attachments/assets/cceceed4-5a6c-4d1a-9ca0-fea96430079d)
<br><br>
5. Wait for model initialisation to complete. The model usually takes a few minutes to initialize, and once it is ready you can use it normally.
![image05](https://github.com/user-attachments/assets/9368e3a7-4d0c-4fc0-abfd-a0b9af712f01)
<br><br>
6. Now the model works fine, and you may notice that the Endpoint URL has been updated, which we'll use later.
![image06](https://github.com/user-attachments/assets/66ff886f-416e-4cb9-9c1a-ec6573c8eeb4)
<br><br>
![image07](https://github.com/user-attachments/assets/92f4c400-b5e0-4939-b439-c03330631bdc)
<br><br>
7. Communicate with one LLM.
<br><br>
Replace `YOUR_API_KEY` to you personal API key. For more information on obtaining API keys for different platforms, refer to this <a href="https://github.com/xufengduan/MacBehaviour/blob/main/Materials/get_api_keys.md">documentation</a>.
<br><br>
In this demo, we'll use `meta-llama/Llama-3.2-3B-Instruct` as the model ID. Or you can try selecting a free model one by one from <a href="https://huggingface.co/models?inference=warm&other=conversational,text-generation-inference&sort=trending">this list of HuggingFace models</a>. You might need to <a href="https://huggingface.co/subscribe/pro">subscribe PRO</a> for access to more advanced models(e.g., Llama 3.2 families).
<br><br>
As we just mentioned, `YOUR_ENDPOINT_URL` refers to the Endpoint_URL generated when the model is run. Since the interaction property of the model is ‘chat_completion’, we should add `/v1/chat/completions` to the end of the URL.
<br><br>
If you have questions about the format `/v1/chat/completions` at the end, check out the MacBehaviour source code <a href="https://github.com/xufengduan/MacBehaviour/blob/c30b1e4388ed19a1dce611bf71bc703dc4bb0c2e/R/tools.R#L206"> here </a>, as this is the default suffix set by the setKey function for the chat_completion model.

```R
setKey(api_key = "YOUR_API_KEY", model = "meta-llama/Llama-3.2-3B-Instruct", api_url = "YOUR_ENDPOINT_URL")
```

8. Load Data: organizes your experimental data from a data frame.
<br><br>
You can find the demo data <a href = "https://github.com/xufengduan/MacBehaviour/blob/main/Materials/Data_OTPR.xlsx">here</a>. If you want to learn more details, please refer to this [tutorial](#tutorial)

```R
df <- read.xlsx("./Data_OTPR.xlsx")  # Load your data file
ExperimentItem <- loadData(runList = df$Run, itemList = df$Item, conditionList = df$Condition, promptList = df$Prompt)
```
9. Set Experimental Design.
```R
Design <- experimentDesign(ExperimentItem, session = 1, randomItem = FALSE)
```
10. Configures model parameters. You can find more parameters <a href = "https://huggingface.co/docs/huggingface_hub/main/en/package_reference/inference_client#huggingface_hub.InferenceClient.chat_completion">here</a>.
```R
gptConfig <- preCheck( data = Design, systemPrompt = "You are a participant in a psychology experiment.", max_tokens = 500)
```
11. Run the Experiment.
```R
runExperiment(gptConfig, savePath = "demo_results.csv")
```
![image08](https://github.com/user-attachments/assets/e3844157-5d02-48f8-9c12-7686e543df4a)
12. View the results. You can write the output (csv file) to results and view it in R studio.
```R
results <- read.csv("demo_results.csv")
View(results)
```
![image09](https://github.com/user-attachments/assets/97410c47-85b6-4490-900b-4c0d26028a61)

## Demo Code - OpenAI

This script provides an example of how to use OpenAI models with the MacBehaviour package.

If you want to learn more about this package, please refer to the [tutorial](#tutorial).

1. Install and load the package. you can skip it if you have already done it.
```R
install.packages("devtools")
devtools::install_github("xufengduan/MacBehaviour", upgrade = "never")
library("MacBehaviour")
```
2. Communicate with one LLM: authenticates API access for the models you are working with.
<br><br>
Replace `YOUR_API_KEY` to you personal API key. For more information on obtaining API keys for different platforms, refer to this <a href="https://github.com/xufengduan/MacBehaviour/blob/main/Materials/get_api_keys.md">documentation</a>.
<br><br>
For the model ID, you can use `gpt-3.5-turbo` or choose from <a href="https://platform.openai.com/docs/models">this list of OpenAI models</a>.
```R
setKey(api_key = "your_api_key_here", model = "gpt-3.5-turbo")
```

3. Load Data: organizes your experimental data from a data frame.
<br><br>
You can find the demo data <a href = "https://github.com/xufengduan/MacBehaviour/blob/main/Materials/Data_OTPR.xlsx">here</a>. If you want to learn more details, please refer to this [tutorial](#tutorial)

```R
df <- read.xlsx("./Data_OTPR.xlsx")  # Load your data file
ExperimentItem <- loadData(runList = df$Run, itemList = df$Item, conditionList = df$Condition, promptList = df$Prompt)
```
4. Set Experimental Design.
```R
Design <- experimentDesign(ExperimentItem, session = 1, randomItem = FALSE)
```
5. Configures model parameters.
You can find more parameters <a href = "https://platform.openai.com/docs/api-reference/chat/create">here</a>.
```R
gptConfig <- preCheck( data = Design, systemPrompt = "You are a participant in a psychology experiment.", max_tokens = 500)
```
6. Run the Experiment.
```R
runExperiment(gptConfig, savePath = "demo_results.csv")
```

## Demo Code - Qianfan Baidu

This is a demo code for models hosted on Baidu's Qianfan platform. You can begin by experimenting with free models such as `yi_34b_chat`/`ernie_speed`, or choose from other models like the Meta-Llama and Mixtral families.

For more details on obtaining API and secret keys, refer to [this guide](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/dlv4pct3s). To browse available models, check [this list](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/Nlks5zkzu#%E5%AF%B9%E8%AF%9Dchat). Be aware that some models require payment for usage, as explained [here](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/hlrk4akp7#%E6%8C%89%E9%87%8F%E5%90%8E%E4%BB%98%E8%B4%B9).


1. Install and load the package. You can skip this if it’s already installed.

```r
install.packages("devtools")
devtools::install_github("xufengduan/MacBehaviour", upgrade = "never")
library("MacBehaviour")
```

2. Communicate with one LLM: authenticate API access for the models you are working with.

Replace `your_api_key_here` and `your_secret_key_here` with your personal API and secret keys. For more information on obtaining API and secret keys, refer to [this documentation](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/dlv4pct3s).

For the model ID, you can use `yi_34b_chat` (currently free. You can check the API price of models [here](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/hlrk4akp7#%E6%8C%89%E9%87%8F%E5%90%8E%E4%BB%98%E8%B4%B9) ) or select from models like Meta-Llama and Mixtral families [here](https://console.bce.baidu.com/qianfan/ais/console/onlineService).
<br>
The string following "chat/" (underlined in the picture) is the model ID.
<img width="1163" alt="Screenshot 2024-10-21 at 12 09 25 AM" src="https://github.com/user-attachments/assets/f6a97c6b-d1f9-4fc1-8cc8-be4d37fefbcc">

```r
setKey(api_key = "your_api_key_here", secret_key = "your_secret_key_here", model = "yi_34b_chat")
```

3. Load Data: organizes your experimental data from a data frame.

You can find the demo data [here](https://github.com/xufengduan/MacBehaviour/blob/main/Materials/Data_OTPR.xlsx). For more details, please refer to the [tutorial](#tutorial).

```r
df <- read.xlsx("./Data_OTPR.xlsx")  # Load your data file
ExperimentItem <- loadData(runList = df$Run, itemList = df$Item, conditionList = df$Condition, promptList = df$Prompt)
```

4. Set Experimental Design.

```r
Design <- experimentDesign(ExperimentItem, session = 1, randomItem = FALSE)
```

5. Configure model parameters.<br>
**Not all models support system prompt in Baidu. For models with this parameter, the systemPrompt should be filled as "", with the additional parameter system which fills you system prompt.**
```r
gptConfig = preCheck(systemPrompt ="", data = Design, checkToken = T,system ="You are a participant in a psychological experiment.")
```

6. Run the Experiment.

```r
runExperiment(gptConfig, savePath = "demo_results.csv")
```



## Tutorial
### 1\. Communicate with Models

Authenticate with LLMs using an API key.

    setKey(api_key = "YOUR_API_KEY", model = "YOUR_MODEL")
    
    # you need to input an additional argument secrect_key = "YOUR_SCRECT_KEY" here to access to Baidu Qianfan platform.
    
    # Then you will receive a message:
    
    ## "Setup api_key successful!"

Arguments: Replace `YOUR_API_KEY` and  `YOUR_MODEL` with your personal key and selected model index.

1) The "api_key" argument, required, needs the user's personal API (Application Programming Interface) from OpenAI, Hugging Face, or other companies. If users are using a self-hosted model, please enter "NA." For more information on obtaining API keys for different platforms, refer to this <a href="https://github.com/xufengduan/MacBehaviour/blob/main/Materials/get_api_keys.md">documentation</a>.

2) The "model" argument, required, a character vector, specifies the index of the selected model.
<br><br>
For OpenAI models, you can find the list of available model indexes <a href="https://platform.openai.com/account/limits">here</a>.
<br><br>
For Hugging Face models, the model name corresponds to the repository name (e.g., meta-llama/Llama-2-13b-hf). A list of available models can be found <a href="https://huggingface.co/models?inference=warm&other=conversational,text-generation-inference&sort=trending">here</a>. You might need to <a href="https://huggingface.co/subscribe/pro">subscribe PRO</a> for access to more advanced models(e.g., Llama 3.1 families).
<br><br>
For self-hosted models, users can find the model's name at the model’s corresponding repository (for a summary, see <a href="https://github.com/lm-sys/FastChat/blob/main/docs/model_support.md">here</a>).

4) The "api_url" argument, optional, a character vector, specifies the interface domain of the selected model. By default, the system will automatically determine the appropriate URL based on the user’s "api_key". Users can still specify a custom api_url, which will take precedence. For experiments using the GPT family, the URLs are documented in <a href="https://platform.openai.com/docs/api-reference/authentication">OpenAI's API reference</a>. For Llama models available through Hugging Face, the model’s URL can be found in the respective model’s repository, such as " https://api-inference.huggingface.co/models/meta-llama/Llama-2-70b-chat-hf". For self-hosted models, please fill this argument with the user’s local URL (for more information, see <a href = "https://github.com/lm-sys/FastChat/blob/main/docs/openai_api.md">here</a>).

</div>

<div id="experiment-design" class="section level3">


### 2\. Experiment Design:

"MacBehaviour" can implement an experiment in two types of designs. 

**1) multiple-trials-per-run design** resembles typical psychological experiments, where a human participant encounters multiple trials in an experiment. Here, you present multiple experimental trials, one by one, to an LLM in a single conversation. Note that earlier input and output will serve as the context for a current trial. 

<img width="442" alt="MTPR" src="https://github.com/user-attachments/assets/8a03e224-b753-43c8-abaa-9170299bc97f">


**2) one-trial-per-run design**, you only present a single trial of prompt and stimulus to an LLM in a conversation, and you present another trial in a new conversation.

<img width="419" alt="OTPR" src="https://github.com/user-attachments/assets/999fac7e-e093-495f-ab45-1bd1ed1d6a18">



### 3\. Demo Experiments:
To illustrate these designs and how to construct the experimental stimuli, we next use a demo experiment. 

Cassidy et al. (1999) showed that speakers of English can infer the gender of novel personal names from phonology. 

In particular, when asked to complete a sentence fragment:

 *After Corlak/Corla went to bed …*

People tend to use a masculine pronoun for names ending in a closed syllable (e.g., *Corlak*) but a feminine pronoun for those ending in an open syllable (e.g., *Corla*). 

In our demo, we ask an LLM to complete sentence fragments and observe how the model refers to the novel personal name (e.g., using masculine pronouns such as *he/him/his* or feminine ones such as *she/her/hers*).


<em>**3.1 multiple-trials-per-run design**</em>

Before using this package, users should prepare one Excel/CSV file/data frame containing the experimental stimuli and other information for experiment design (see Table 1).



   **Table 1**. **The data frame structure**

   | **Column**    | **Description**                                              |
   | ------------- | ------------------------------------------------------------ |
   | **Run**       | The index of the conversation with the  model, akin to the concept of "list" in a psychological experiment.  Items shared with the same Run index will be presented in a single  conversation. |
   | **Item**      | Indicates the item index of stimuli for  data tracking and organization. |
   | **Condition** | Specifies the experimental condition  associated with each stimulus, for researcher's reference. |
   | **Prompt**    | Contains the actual prompt,  together with a stimulus, presented to the model |

   **Note.** Each row stands for a unique stimulus in the data frame/sheet.

The Excel file/data frame should exhibit a structured format, defining columns for "Run", "Item", "Condition", and "Prompt", with each row standing for a unique stimulus (see Table 1 for a description of these terms and Table 2 for an example). 

In the multiple-trials-per-run design, multiple trials (four trials in our demo) are presented in a single conversation (Run). 

In each Run, the package will send the stimulus based on the index of row. Users can randomize item order within Runs in the function "experimentDesign" later. The LLM will use input (prompts and stimuli) and model output (responses) in earlier trials as its context (see Figure 1 for an example of conversation/Run).

   **Table 2**. **An exemplar stimulus file in a multiple-trials-per-run design**

   | **Run** | **Item** | **Condition**    | **Prompt**                                                   |
   | ------- | -------- | ---------------- | ------------------------------------------------------------ |
   | 1       | 1        | Open  syllable   | Please repeat the fragment and complete it  into a full sentence: Although Pelcra was sick … |
   | 1       | 2        | Closed syllable  | Please repeat the fragment and complete it  into a full sentence: Because Steban was very careless … |
   | 1       | 3        | Open  syllable   | Please repeat the fragment and complete it  into a full sentence: When Hispa was going to work … |
   | 1       | 4        | Closed  syllable | Please repeat the fragment and complete it  into a full sentence: Before Bonteed went to college … |
   | 2       | 1        | Closed  syllable | Please repeat the fragment and complete it  into a full sentence: Although Pelcrad was sick … |
   | 2       | 2        | Open  syllable   | Please repeat the fragment and complete it  into a full sentence: Because Steba was very careless … |
   | 2       | 3        | Closed  syllable | Please repeat the fragment and complete it  into a full sentence: When Hispad was going to work … |
   | 2       | 4        | Open  syllable   | Please repeat the fragment and complete it  into a full sentence: Before Bontee went to college … |


   There are two roles in the context: "user" (for sending stimuli) and "assistant" (as a participant to provide responses). To achieve the above conversation, this package sends the stimuli in the following format for OpenAI GPT series/open-source models and Llama2:

    

   ```r
   # OpenAI/Open-source models
   
   # For the first trial: 
   
   list(role = "user", content = "Please repeat the fragment and complete it into a full sentence: Although Pelcra was sick … ") 
   
    
   
   # For the second trial:
   
   [list (role = "user", content = "Please repeat the fragment and complete it into a full sentence: Although Pelcra was sick … "),
   
   list (role = "assistant", content = " Although Pelcra was sick, she remained determined to finish her project on time. "),
   
   list (role = "user", content = " Please repeat the fragment and complete it into a full sentence: Because Steban was very careless …")]
   ```

    

   The conversational context was provided as the beginning of the next trial’s prompt. In this example, the context included the first stimulus *Please repeat the fragment and complete it into a full sentence: Although Pelcra was sick …* and its response *Although Pelcra was sick, she remained determined to finish her project on time.* The prompt then presented the second stimulus *Please repeat the fragment and complete it into a full sentence: Because Steban was very careless …* after the conversational context. We implemented this function for Llama-2-chat-hf series in the same way (see <a href="https://huggingface.co/blog/llama2#how-to-prompt-llama-2">here</a> for details). 

    

<em>**3.2 One-trial-per-run Design**</em>

    In the one-trial-per-run design, an LLM will be presented only one trial of the experiment in a Run/conversation. In our demo experiment (see Table 3), for instance, each conversation with the LLM involves only one stimulus. In this design, each stimulus is given a unique Run number, indicating that each one is to be presented in a separate conversation with the LLM. This design eliminates the potential for previous context to influence the response of current stimulus, ensuring that each stimulus is evaluated independently.

    

   **Table 3**. **Stimuli for one-trial-per-run design**

   | **Run** | **Item** | **Condition**   | **Prompt**                                                   |
   | ------- | -------- | --------------- | ------------------------------------------------------------ |
   | 1       | 1        | Open syllable   | Please repeat the fragment and complete it  into a full sentence: Although Pelcra was sick … |
   | 2       | 1        | Closed syllable | Please repeat the fragment and complete it  into a full sentence: Although Pelcrad was sick … |
   | 3       | 2        | Open syllable   | Please repeat the fragment and complete it  into a full sentence: Because Steba was very careless … |
   | 4       | 2        | Closed syllable | Please repeat the fragment and complete it  into a full sentence: Because Steban was very careless … |
   | 5       | 3        | Open syllable   | Please repeat the fragment and complete it  into a full sentence: When Hispa was going to work … |
   | 6       | 3        | Closed syllable | Please repeat the fragment and complete it  into a full sentence: When Hispad was going to work … |
   | 7       | 4        | Open syllable   | Please repeat the fragment and complete it  into a full sentence: Before Bontee went to college … |
   | 8       | 4        | Closed syllable | Please repeat the fragment and complete it  into a full sentence: Before Bonteed went to college … |

    

Load your stimuli from an Excel file.

    df = read.xlsx("/path/to/excel/demo.xlsx")


<table>
<thead>

<tr class="header">

<th>Run</th>

<th>Item</th>

<th>Condition</th>

<th>Content</th>

</tr>

</thead>

</table>

The `read.xlsx` function from the `openxlsx` package reads the file, converting it into a data frame within R. To accurately use the stimuli within the R environment, the `loadData` function is utilized, which translates the structured data from an Excel file/data frame into an organized data frame within R:

```r
ExperimentItem = loadData(runList=df$Run, itemList=df$Item, conditionList=df$Condition, promptList=df$Prompt)
```

Arguments: This function prepares the stimuli from your Excel data.

The "loadData" function maps vectors or data frame columns to specific keywords. These keywords are then recognized by subsequent functions in our framework. This mapping streamlines the automatic identification and processing of relevant data collection:

1) The "runList", required, a numeric vector, matches the column for "Run" in the CSV file and denotes the conversation/run index. It is utilized in loops for interactions with LLMs. The vector's name (e.g., df$Run) can be arbitrary; what's important is the content specified by users for the runList. This applies to subsequent parameters in this function as well.

2) The "itemList", required, a numeric vector, refers to the column for "Item", indicating the item index of stimuli. This is for the researcher's reference and does not interact with the model's operation. It will be used in loops for interactions with LLMs.

3) The "conditionList", required, a numeric/character vector, represents the column for "Condition", which specifies the experimental condition associated with each stimulus. Similar to "itemList", it is for the researcher's reference and does not interact with the model's operation.

4) The "promptList", required, a character vector, maps to the column for "Prompt", which contains the actual prompts that will be presented to the model during the experiment. Each element under this column is a unique prompt the language model will process and respond to. 


The output of this function, "ExperimentItem", is a data frame generated by "loadData", which includes all the necessary details for each stimulus. The accuracy of "loadData" in mapping the CSV spreadsheet/data frame to the "ExperimentItem" is of pivotal importance, as it ensures that each stimulus is precisely presented according to the experimental design.

   Next, the "experimentDesign" function allows users to define the structure and sequence of the experimental Runs (conversation):

   ```R
   Design = experimentDesign(ExperimentItem, session = 1, randomItem = F)
   ```

   1) "ExperimentItem", required, a data frame, is the output of function "loadData", which is a structured data frame for storing stimuli and experimental information (e.g., item, condition, and prompt for each stimulus).
   2) The "Session", optional, an integer, specifies the number of iterations for all stimuli. The default value is 1. It adds a new column named "session" to your data frame, where each session includes all original stimuli. If the "Session" is set to 2, the package collects data for one session and then repeats all stimuli for a second session.
   3) "randomItem", optional, a logical vector, is available to randomize the order of item presentation within a run (conversation). It automatically remains "FALSE" for the one-trial-per-run design. 

<div id="model-parameters" class="section level3">


<em>**3.3 Model Parameters**</em>

The model parameters are configured to guide the behaviour of the model during the experiment in the "preCheck" function(for HuggingFace models see <a href = "https://huggingface.co/docs/huggingface_hub/main/en/package_reference/inference_client#huggingface_hub.InferenceClient.chat_completion">here</a>; for OpenAI models, please see <a href = "https://platform.openai.com/docs/api-reference/chat/create">here</a>):

 

```r
gptConfig = preCheck (data = Design, checkToken = F, systemPrompt = "You are a participant in a psychological experiment", max_tokens = 500, temperature = 0.7, n = 1)
```

 

1) "data", required, a data frame, is the output of experimentDesign function.

2) The "systemPrompt", optional, a character vector, offers a task instruction to the model analogous to the instructions given to participants in a psychological experiment. Should one wish to convey the instructions to the model through the trial prompt, one could leave this parameter blank or state some general instructions (e.g., "You are a participant in a psychological experiment, please follow the task instruction carefully"). By default, it is empty. If not, the package will send the systemPrompt content at the start of each run.

``` r
[list(role = "system", content = " You are a participant in a psychological experiment, please follow the task instruction carefully."),
(role = "user", content = "Please repeat the fragment and complete it into a full sentence: Although Pelcra was sick …"),
…]
```

3) The "max_tokens", optional, a numeric vector, limits the length of the model's response. This may lead to an incomplete response if the tokens of response intended by a model exceed this value. The default is Null.

4) The "checkToken", optional, a logical vector, allows users to conduct a token count in order to determine whether their trial(s) have more tokens than a model allows in a single conversation. The default setting, however, is FALSE. When set to TRUE, the package initiates the upload of your experimental stimuli to the tokenizer server of this package for token counting (note that your stimuli will not be retained on the server; they will be promptly removed after the necessary calculations are completed). Our server uses tokenizer algorithms from OpenAI (https://github.com/openai/tiktoken) and Hugging Face (https://github.com/huggingface/transformers/), supporting over 250 models, including OpenAI family, Llama and BERT, automatically selecting the appropriate tokenizer for each. If an unsupported model is chosen, users are alerted with a warning in their report indicating that results were calculated using GPT-2 as the default tokenizer. This ensures transparency about which tokenizer was used, helping users make informed decisions.
   For example, consider a study with a one-trial-per-run design that includes 40 items and 100 sessions, where the item with the highest number of tokens has 137. The "checkToken" function generates tailored reports according to your experiment's design. For instance:

    ```r
    # One-trial-per-run design
    #	CheckItem			Values
    # 1	item numbers		   4000
    # 2	max_token_numbers	    137
    ```
    In the report, the "item numbers" show the number of items you have (number of items × number of sessions). The value of "max_token_numbers" signifies the maximum token length among all experimental items. It should not exceed the input token limit of an LLM. 

    ```r
    # Multiple-trials-per-run design
    # Run		max_tokens_per_run
    # 1		    1756
    # 2 		2016
    # …
    ```
    
    In the report for multiple-trials-per-run design, the package computes the input for the last trial of a run—incorporating all previous conversation history—based on the maximum token count. This is calculated as (systemPrompt + max_tokens) × number of trials + previous conversation history + tokens from the last item; it then reports this total for each run. Please make sure that the max token per run does not exceed the token limit of your selected LLM. The following is an example report. 

5) The "logprobs", optional, a boolean vector, specifies whether to return the log probabilities of output tokens in the chat completion mode. It appends the log probability for each token in the response under the "rawResponse" column. Additionally, users can define how many top probable tokens to display at each token position by introducing a numeric vector “top_logprobs”, which ranges from 0 to 20 (for <a href="https://platform.openai.com/docs/api-reference/chat/create#chat-create-logprobs"> OpenAI GPT families</a> only, for HuggingFace models see <a href = "https://huggingface.co/docs/huggingface_hub/main/en/package_reference/inference_client#huggingface_hub.InferenceClient.chat_completion">here</a>), showing their corresponding log probabilities. Please note that "logprobs" must be active for this feature to work. Setting it to 2 returns the two most likely tokens at that position. For instance, if "logprobs" is set to TRUE and "top_logprobs" is set to 2, a generated response might be: “Hello! How can I assist you today?” For the first token “Hello”, two alternatives are provided:

``` {"top_logprobs": [{"token": "Hello", "logprob": -0.31725305}, {"token": "Hi", "logprob": -1.3190403}]}```

- This configuration also provides the two most probable tokens and their respective log probabilities for each subsequent token position. 
In the text completion mode (detailed in "api_url" part in [Communicate with Models](#1-communicate-with-models)) in the GPT family, "logprobs" is limited to a numeric vector with a maximum value of 5;  For self-hosted models, currently, only text completion supports collecting token probabilities by setting logprobs to True. This randomly returns one token and its probability at a time, but users can continue requesting until they receive the desired token.

6) imgDetail, optional, offers three settings for image input: low, high, or auto. This allows users to control the model's image processing and textual interpretation. By default, the model operates in "auto" mode, automatically selecting between low and high settings based on the input image size (see more for https://platform.openai.com/docs/guides/vision/low-or-high-fidelity-image-understanding). If inputs do not include images, please skip this parameter.

7) The <a href="https://platform.openai.com/docs/api-reference/chat/create#chat-create-temperature">"temperature"</a>, optional, a numeric vector, controls the creativity in LLM’s responses. 

8) The <a href="https://platform.openai.com/docs/api-reference/chat/create#chat-create-n">"n"</a>, optional, a numeric vector, determines how many unique and independent responses are produced by the model for a single trial. For example, if n = 20, users will get 20 unique responses for each request. However, in a multiple-trials-per-run design, this parameter is automatically disabled to prevent branching conversations.
   
In addition to the parameters mentioned above, users can also enter optional ones(for HuggingFace models see <a href = "https://huggingface.co/docs/huggingface_hub/main/en/package_reference/inference_client#huggingface_hub.InferenceClient.chat_completion">here</a>; for OpenAI models, please see <a href = "https://platform.openai.com/docs/api-reference/chat/create">here</a>).

<div id="run-the-experiment" class="section level3">

<em>**3.4 Run the Experiment**</em>

1. The "runExperiment" function is the execution phase of data collection. It initiates the interaction with an LLM based on the specified design and parameters, and iteratively collects responses to the stimuli.

   

  ```r
runExperiment (gptConfig, savePath = "./demo.xlsx")
  ```

    1) "gptConfig" is the configuration list object containing all the details of the experiment setup, including the system prompt, chosen model, maximum tokens, temperature, the number of responses and other parameters. This object is crafted in the preceding steps "preCheck".
    2) "savePath" is the file path where the experiment results will be saved. This should be an accessible directory on the user's machine with the appropriate write permissions. A file name in the path with either the ".xlsx" or ".csv" extension indicates that its contents are saved in "xlsx" or "csv" format, respectively. These formats are particularly friendly for users who may wish to perform additional data manipulation or visualization within spreadsheet software or import the data into statistical software packages for further analysis.

  When "runExperiment" is active, the package sends a prompt to the selected language model, records the model’s output, and then moves on to the next stimulus as per the experiment design. 

<div id="run-the-experiment" class="section level3">



### 4\. Result Structure

Upon the completion of the experiment, the responses are compiled into a file. This file consists of multiple columns including Run, ItemID, Condition, Prompt, the corresponding response from the LLM and other information. The output file typically has the following columns:
 

**Table 4**. The data structure of output file.

| **Column**    | **Description**                                            |
| ------------- | ---------------------------------------------------------- |
| **Run**       | The conversation index.                                    |
| **Item**      | Indicates the Item number.                                 |
| **Condition** | Details the condition under which the item  was presented  |
| **Prompt**    | Contains the original stimulus content sent  to the model. |
| **Response**  | The model's response to the stimulus.                      |
| **n**         | The response index in a single request.                    |
| **Trial**     | The turn index of a conversation.                          |
| **Message**   | The actual prompt sending to an LLM.                       |
| **RawResponse**| The raw response from Model's API.                       |

</div>

### 
