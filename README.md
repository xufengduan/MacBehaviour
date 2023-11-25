<div class="container-fluid main-container">


<div class="row">


<div class="toc-content col-xs-12 col-sm-8 col-md-9">


<div id="header">


# MacBehaviour R package Tutorial

</div>

The `MacBehaviour` R package offers a user-friendly toolkit for norming experimental stimuli, and replicating classic experiments. The package provides a suite of functions tailored for experiments with LLMs, including those from OpenAI's GPT series, Llama 2 Chat series in Huggingface, and open-source models.

<div id="installing-and-loading-necessary-packages" class="section level3">


### 1\. Install and load package:

```R
install.packages("devtools")
devtools::install_github("xufengduan/MacBehaviour")


# Upon the successful installation, users can load this package into the current R session:


library("MacBehaviour")


```

<div id="set-api-key" class="section level3">


### 2\. Set API Key:

Authenticate with OpenAI using an API key.

    setKey(api_key = "YOUR_API_KEY", api_url = "YOUR_MODEL_URL", model = "YOUR_MODEL")
    
    ## [1] "Setup api_key successful!"
    ## [1] "your api_key: sk-XXXXXXXXXXXXXXXXXX"

Arguments: Replace `YOUR_OPENAI_API_KEY` with your personal key.

1) The "api_key" argument in this function requires your personal API key from OpenAI or Hugging Face. Please fill "NA", if you are using a self-deployed model. API enables authenticated access to language models. Researchers interested in obtaining OpenAI API key should first sign up on the OpenAI platform (https://platform.openai.com/). After registration, navigate to your account settings where you can generate your personal API key. Similarly, for integrating Hugging Face models into your research, an API key specific to Hugging Face is required. This can be obtained by creating an account on the Hugging Face platform (https://huggingface.co/). Once you are logged in, access your account settings, and find the "access token" to generate your Hugging Face API key. Please note that as the model inference needs GPUs, you may need to pay inference cost to OpenAI (https://openai.com/pricing) or Hugging Face (https://huggingface.co/blog/inference-pro) for using Llama-2-chat-hf series.

2) The "api_url" argument specifies the interface domain of the selected model. For experiments using GPT series, use the URL: "https://api.openai.com/v1/chat/completions" as documented in OpenAI's API reference (https://platform.openai.com/docs/api-reference/authentication). For Llama-2-chat-hf models available through Hugging Face, the model’s URL can be found in the respective model’s repository, such as "https://huggingface.co/meta-llama/Llama-2-70b-chat-hf ". For self-deployed model, please fill this argument with your local URL (Please find more information at https://github.com/lm-sys/FastChat/blob/main/docs/openai_api.md).

3) The "model" argument, a character vector, ensures the experiment is conducted using the desired model. You can find the list of available model indexes here: (https://platform.openai.com/account/limits). For Llama-2-chat-hf series, please put in "Llama2". For self-deployed models, you can find the model's name at model’s corresponding repository (for a summary, see https://github.com/lm-sys/FastChat/blob/main/docs/model_support.md).

</div>

<div id="experiment-design" class="section level3">


### 3\. Experiment design:

"MacBehaviour" can implement an experiment in two types of designs. 
**1) multiple-trials-per-run design** resembles typical psychological experiments, where a human participant encounters multiple trials in an experiment. Here, you present multiple experimental trials, one by one, to an LLM in a single conversation. Note that earlier input and output will serve as the context for a current trial. 
**2) one-trial-per-run design**, you only present a single trial of prompt and stimulus to an LLM in a conversation, and you present another trial in a new conversation.

To illustrate these designs and how to construct the experimental stimuli, we next use a demo experiment. Cassidy et al. (1999) showed that speakers of English can infer the gender of novel personal names from phonology. In particular, when asked to complete a sentence fragment (e.g., *After Corlak/Corla went to bed …*), people tend to use a masculine pronoun for names ending in a closed syllable (e.g., *Corlak*) but a feminine pronoun for those ending in an open syllable (e.g., *Corla*). Cai et al. (2023) replicated the experiment with ChatGPT and Vicuna and obtained a similar phonology-gender association in these LLMs. In the following parts, we show how to use the "MacBehaviour" package, using this experiment as an example. Following Cai et al. (2023), in our demo, we ask an LLM to complete sentence fragments and observe how the model refers to the novel personal name (e.g., using masculine pronouns such as *he/him/his* or feminine ones such as *she/her/hers*).

1. **multiple-trials-per-run design**,
Before using this package, users should prepare one Excel file/data frame containing the experimental stimuli and other information for experiment design (see Table 3). The Excel file/data frame should exhibit a structured format, defining columns for "Run", "Item", "Condition", and "Prompt", with each row standing for a unique stimulus (see Table 3 for a description of these terms and Table 4 for an example). This organization is pivotal for keeping the integrity of the experimental design, ensuring each stimulus is correctly identified and presented as your experiment design during the experiment.

   **Table 3**. The data frame structure 

   | **Column**    | **Description**                                              |
   | ------------- | ------------------------------------------------------------ |
   | **Run**       | The index of the conversation with the  model, akin to the concept of "list" in a psychological experiment.  Items shared with the same Run index will be presented in a single  conversation. |
   | **Item**      | Indicates the item index of stimuli for  data tracking and organization. |
   | **Condition** | Specifies the experimental condition  associated with each stimulus, for researcher's reference. |
   | **Prompt**    | Contains the actual prompt,  together with a stimulus, presented to the model |

   **Note.** Each row stands for a unique stimulus in the data frame/sheet.

   

   **Table 4**. An exemplar stimulus file in a multiple-trials-per-run design

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

    In the multiple-trials-per-run design (see Table 4), multiple trials (four trials in our demo) are presented in a single conversation (Run). In each Run, the package will send the stimulus based on the index of row. Users can randomize item order within Runs in the function "experimentDesign" later. The LLM will use input (prompts and stimuli) and model output (responses) in earlier trials as its context (see Figure 1 for an example of conversation/Run).

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

    

   The conversational context was provided as the beginning of the next trial’s prompt. In this example, the context included the first stimulus *Please repeat the fragment and complete it into a full sentence: Although Pelcra was sick …* and its response *Although Pelcra was sick, she remained determined to finish her project on time.* The prompt then presented the second stimulus *Please repeat the fragment and complete it into a full sentence: Because Steban was very careless …* after the conversational context. We implemented this function for Llama-2-chat-hf series in the same way (see more at [https://Huggingface.co/blog/llama2#how-to-prompt-llama-2](https://huggingface.co/blog/llama2#how-to-prompt-llama-2)). 

    

2. **one-trial-per-run design**

    In the one-trial-per-run design, an LLM will be presented only one trial of the experiment in a Run/conversation. In our demo experiment (see Table 5), for instance, each conversation with the LLM involves only one stimulus. In this design, each stimulus is given a unique Run number, indicating that each one is to be presented in a separate conversation with the LLM. This design eliminates the potential for previous context to influence the response of current stimulus, ensuring that each stimulus is evaluated independently.

    

   **Table 5**. Stimuli for one-trial-per-run design

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

The "read.xlsx" function from the "openxlsx" package reads the Excel file, converting it into a data frame within R. You can also import a data frame containing stimuli and experiment information through other functions. To accurately present the stimuli within the R environment, the "loadData" function is utilized, which organized the data from a data frame for further processing:

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
ExperimentItem = loadData(runList=df$Run, itemIDList=df$Item, conditionList=df$Condition, promptList=df$Prompt)
```

Arguments: This function prepares the stimuli from your Excel data.

Each argument of the `loadData` function maps to a specific column in the provided Excel spreadsheet/data frame, ensuring that the data's integrity is preserved and appropriately structured for the experiment's needs:

1) The "runList", a numeric vector, corresponds to the "Run" column in the Excel file, which indicates the index of the conversation/Run.

2) The "runList", a numeric vector, corresponds to the "Run" column in the Excel file, which indicates the index of the conversation/Run.

3) The "itemIDList", a numeric vector, refers to the "Item" column, indicating the item index of your stimuli. This is for the researcher's reference and does not interact with the model's operation.

4) The "conditionList", a numeric/character vector, represents the "Condition" column, which specifies the experimental condition associated with each stimulus. Similar to "itemIDList", it is for the researcher's reference and does not interact with the model's operation.

5) The "promptList", a character vector, argument maps to the "Prompt" column, which contains the actual prompts that will be presented to the model during the experiment. Each element under this column is a unique prompt that the language model will process and respond to.

6) The output of this function, "ExperimentItem", is a data frame generated by "loadData", which includes all the necessary details for each stimulus. The accuracy of "loadData" in mapping the Excel spreadsheet/data frame to the "ExperimentItem" is important, as it ensures that each stimulus is precisely presented according to the experimental design, thereby guaranteeing the validity and reliability of the experimental results.

   Next, the "experimentDesign" function allows users to define the structure and sequence of the experimental Runs (conversation):

   ```R
   Design = experimentDesign(ExperimentItem, Step=1, random = F)
   ```

   1) "ExperimentItem", a data frame, is the output of function "loadData", which is a structured data frame for storing stimuli and experimental information (e.g., item, condition, and prompt for each stimulus).
   2) "Step", an integer, determines the iteration count for all stimuli in a Run. This argument creates a new column "Session" in your data frame. Each session contains all the stimuli of the original data frame (e.g., ExperimentItem). The number of session dependents on the argument "Step". To illustrate, if Step equals 2, then after the package collects data for a Run in first session, it will repeat the process (second session) to gather more responses from the same Run. This results in two sessions of responses being obtained for that specific Run.
   3) "random", a logical vector, is available to randomize the order of stimuli presentation within a Run (conversation). It should remain "FALSE" for the one-trial-per-run design. Users can randomize the order of stimuli within a session by setting "TRUE".


<div id="model-parameters" class="section level3">


### 4\. Model parameters

The model parameters are configured to guide the behaviour of the model during the experiment in the "preCheck" function:

 

```r
gptConfig = preCheck (Design, checkToken = F, systemPrompt = "You are a participant in a psycholinguistic experiment", max_tokens = 500, temperature = 0.7, top_p =1, n = 1)
```

 

1) "Design", a data frame, is the output of experimentDesign function.
2) The "systemPrompt", a character vector, offers a task instruction to the model analogous to the instructions given to participants in a psychological experiment. Should one wish to convey the instructions to the model through the trial prompt, this parameter can be left blank here or say some rules in general, such as "You are a participant in a psycholinguistics experiment, please follow the task instruction carefully." Default is empty.
3) The "checkToken", a logical vector, allows users to conduct a token count in order to determine whether their trial(s) have more tokens than a model allows in a single conversation. The default setting, however, is FALSE. When set to TRUE, the package initiates the upload of your experimental stimuli to the tokenizer server of this package for token counting. This server implemented a tokenizer algorithm provided by OpenAI's GitHub repository (https://github.com/openai/tiktoken) specifically designed for use with GPT 3.5. However, please note that these estimates may not always correspond to accurate values for all LLMs. It is important to note that your submitted stimuli are not retained on the server. They are promptly deleted after the necessary calculations are completed. The "checkToken" function generates varying reports tailored to your specific experimental design. For instance:

 

\# one-trial-per-run design

\#       CheckItem                           Values

\# 1     item numbers                        1200

\# 2     max_token_numbers               137

 

The "item numbers" shows the number of items you have (the number of items* Step). The value of "max_token_numbers" signifies the maximum token length among all experimental items. It should not exceed the model’s input limits. 

In the report for a multiple-trials-per-run design, the package calculates the last trial of one Run (containing all conversational history) as max token number, that is, (systemPrompt + max_tokens) * trial + previous conversation history+ token of last item; it then reports this number for each Run. Please make sure that the max token per Run should not exceed the LLM’s token limit. For instance:

 

\# multiple-trials-per-run design

\# Run         max_tokens_per_run

\# 1             756

\# 2             1016

\# …

 

4) The "max_tokens", a numeric vector, limits the length of the model's response. This may lead to an incomplete response if the tokens of response intended by a model exceed this value. Default is 500.
5) The "temperature", a numeric vector, controls the variability/creativity in LLM’s responses. Default is 1.
6) The "top_p", a numeric vector, is another way controls the variability/creativity in LLM’s responses. A top_p of 0.1 signifies that the model only evaluates token within the hight 10% of the probability distribution. It is usually adivised to modify either this setting or temperature parameter, but not both simultaneously (keep it as default value 1, when you adjust the temperature parameter from default). 
7) The "n", a numeric vector, is only available for OpenAI GPT series. Please put in "1" if you use other LLMs. This argument specifies the number of responses for each trial. If n = 20, there will be 20 responses for each request. Note that, for multiple-trials-per-run design, this parameter must be set to 1 to avoid branching conversations

<div id="run-the-experiment" class="section level3">


### 5\. Data collection

1. The "runExperiment" function is the execution phase of data collection. It initiates the interaction with an LLM based on the specified design and parameters, and iteratively collects responses to the stimuli.

   

  ```r
runExperiment (gptConfig, savePath = "./demo.xlsx")
  ```

    1) "gptConfig" is the configuration list object containing all the details of the experiment setup, including the system prompt, chosen model, maximum tokens, temperature, the number of responses and other parameters. This object is crafted in the preceding steps "preCheck".
    2) "savePath" is the file path where the experiment results will be saved. This should be an accessible directory on the user's machine with the appropriate write permissions. A file name in the path with either the ".xlsx" or ".csv" extension indicates that its contents are saved in "xlsx" or "csv" format, respectively. These formats are particularly friendly for users who may wish to perform additional data manipulation or visualization within spreadsheet software or import the data into statistical software packages for further analysis.

  When "runExperiment" is active, the package sends a prompt to the selected language model, records the model’s output, and then moves on to the next stimulus as per the experiment design. 

<div id="run-the-experiment" class="section level3">



### 6\. Result structure

Upon the completion of the experiment, the responses are compiled into a file. This file consists of multiple columns including Run, ItemID, Condition, Prompt, the corresponding response from the LLM and other information. The output file typically has the following columns:

 

 

**Table 6**. The data structure of output file.

| **Column**    | **Description**                                            |
| ------------- | ---------------------------------------------------------- |
| **Run**       | The conversation index.                                    |
| **ItemID**    | Indicates the Item number.                                 |
| **Condition** | Details the condition under which the item  was presented  |
| **Prompt**    | Contains the original stimulus content sent  to the model. |
| **Response**  | The model's response to the stimulus.                      |
| **n**         | The response index in a single request.                    |
| **Trial**     | The turn index of a conversation.                          |
| **Message**   | The actual prompt sending to an LLM.                       |

</div>

### 
