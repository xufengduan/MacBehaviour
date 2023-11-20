<div class="container-fluid main-container">

<div class="row">

<div class="toc-content col-xs-12 col-sm-8 col-md-9">

<div id="header">

# MacBehaviour R package Tutorial

</div>

The `MacBehaviour` R package offers a user-friendly toolkit for norming experimental stimuli, and replicating classic experiments. The package provides a suite of functions tailored for experiments with LLMs, including those from OpenAI's GPT series, Llama 2 Chat series in Huggingface, and open-source models.

<div id="installing-and-loading-necessary-packages" class="section level3">

### 1\. Install and load package:

    install.packages("devtools")
    devtools::install_github("xufengduan/MacBehaviour")
    library(MacBehaviour)

</div>

<div id="set-api-key" class="section level3">

### 2\. Set API Key:

Authenticate with OpenAI using an API key.

    setKey(api_key = "YOUR_API_KEY", api_url = "YOUR_MODEL_URL", model = "")

    ## [1] "Setup api_key successful!"
    ## [1] "your api_key: sk-XXXXXXXXXXXXXXXXXX"

Arguments: Replace `YOUR_OPENAI_API_KEY` with your personal key.

1) The **api_key** argument in this function requires your personal API key from OpenAI or Huggingface. Please fill "NA", if you are using self-deployed model. API enables authenticated access to language models. Researchers interested in obtaining OpenAI API key should first sign up on the OpenAI platform (https://openai.com/). After registration, navigate to your account settings where you can generate and retrieve your unique API key. Similarly, for integrating Huggingface models into your research, an API key specific to Huggingface is required. This can be obtained by creating an account on the Huggingface platform (https://huggingface.co/). Once you are logged in, access your account settings to find and generate your Huggingface API key. Please note that as the model inference needs GPUs, you may need to pay inference cost to OpenAI (https://openai.com/pricing) or Huggingface (https://huggingface.co/blog/inference-pro).

2) The **api_url** argument specifies the interface domain of the selected model. For experiments using the GPT series, use the URL "https://api.openai.com/v1/chat/completions" as documented in OpenAI's API reference (https://platform.openai.com/docs/api-reference/authentication). For Llama2 Chat models available through Huggingface, the model’s URL can be found in the respective model’s repository, such as "https://api-inference.huggingface.co/models/meta-llama/Llama-2-70b-hf" for specific models. For self-deployed model, please fill this argument with your local url (Please find more information in https://github.com/lm-sys/FastChat/blob/main/docs/openai_api.md).

3) The **model** argument, a character vector, ensures the experiment is conducted using the desired GPT series, taking into account the computational cost and the capabilities of the chosen model. You can find the list of available model indexes here: (https://platform.openai.com/account/limits). For Llama 2 Chat series, please put in "Llama2". For self-deployed models, you can find the model name at model’s corresponding repository (for a summary see https://github.com/lm-sys/FastChat/blob/main/docs/model_support.md).

</div>

<div id="experiment-design" class="section level3">

### 3\. Experiment design:

MacBehaviour can implement an experiment in two types of designs. A **multiple-trials-per-run design** resembles typical psychological experiments, where a human participant encounters multiple trials in an experiment. Here, you present multiple experimental trials, one by one, to an LLM in a single conversation. Note that previous input and output will serve as the context for a current trial. In a **one-trial-per-run design**, you only present a single trial of prompt and stimulus to an LLM in a conversation and you present another trial in another conversation.

1) In the **multiple-trials-per-run design**, multiple trials are presented in a single conversation (Run). In each run the package will send the stimuli based on the index of row. The LLM will use input (prompts and stimuli) and model output (responses) in previous trials as its context, depending on the length of previous input and output and the contextual memory allowed in a model. 

2) In the **one-trial-per-run design**, an LLM will be presented only on trial of the experiment in a run/conversation. In our demo experiment, for instance, each conversation with the LLM involves only one prompt and stimulus. In this design, each stimulus is given a unique Run number, indicating that each stimulus is to be presented in a separate conversation with the LLM. This design eliminates the potential for previous context to influence the response of current stimulus, ensuring that each stimulus is evaluated independently.


Load your stimuli from an Excel file.

    df = read.xlsx("/path/to/excel/demo.xlsx")

The file should have the following format:

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

    ExperimentItem = loadData(runList=df$Run, itemIDList=df$Item, conditionList=df$Condition, targetPrompt=df$Prompt)

Arguments: This function prepares the stimuli from your Excel data.

Each argument of the `loadData` function maps to a specific column in the provided Excel spreadsheet/data frame, ensuring that the data's integrity is preserved and appropriately structured for the experiment's needs:
1) The **runList**, a numeric vector, corresponds to the "Run" column in the Excel file, which designates the index of the conversation/run with the model.
2) The **itemIDList**, a numeric vector, refers to the "Item" column, indicating the item index of your stimuli. 
3) The **conditionList**, a numeric/character vector, represents the "Condition" column, which specifies the experimental condition associated with each stimulus. Similar to `itemIDList`, this is for the researcher's reference and does not interact with the model's operation. 
4) The **targetPrompt**, a character vector, argument maps to the "Prompt" column, which contains the actual prompts that will be presented to the model during the experiment. Each entry under this column is a unique prompt that the language model will process and respond to, forming the core of the experimental data collection.
The output of this function, "ExperimentItem", is a dataframe generated by "loadData", which includes all the necessary details for each stimulus as it is to be presented to an LLM. The accuracy of "loadData" in mapping the Excel spreadsheet to the "ExperimentItem" list is important, as it ensures that each stimulus is precisely presented according to the experimental design, thereby guaranteeing the validity and reliability of the experimental results.
The "experimentDesign" function allows users to define the structure and sequence of the experimental runs:

    Design = experimentDesign(ExperimentItem, Step=1, random = F)

1) **ExperimentItem**, a data frame, is the output of function "loadData", which is a structured data frame for storing stimuli and experimental information (e.g., item, condition, and prompt for each stimulus).
2) **Step**, an integer, defines how many iterations (Sessions) a run will have. For instance, with Step = 2, the package interacts with a LLM and gathers responses twice per run (two Sessions).
3) **random**, a logical vector, is available to randomize the order of stimuli presentation within a run (conversation). It should remain false ("False") for experiments that uses the one-trial-per-run design.
The output "Design" is a data frame containing a new column named "Session". Each session contains all the stimuli in your original stimuli data frame (e.g., ExperimentItem). The number of session dependents on the argument "Step", user can random the order of stimuli within a session by setting "True" for "random". 

</div>

</div>

</div>

<div id="model-parameters" class="section level3">
  
### 4\. Model parameters
The Model parameters are configured to guide the behaviour of the model during the experiment. The "preCheck" function establishes these parameters:

    gptConfig = preCheck(Design, systemPrompt="You are a participant in a psycholinguistic experiment", max_tokens=500, temperature=0.7, n=1)
    
1) **Design**, a data frame, is the output of experimentDesign function.
2) The **systemPrompt**, a character vector, offers a task instruction to the model analogous to the instructions given to participants in a psychological experiment. Should one wish to convey the instructions to the model through the trial prompt, this parameter can be left blank here or say some rules in general, such as "You are a participant in psycholinguistics experiment, please follow the task instruction carefully." Default is empty.
3) The **max_tokens**, a numeric vector, caps the length of the model's response. This may lead to an incomplete response if the tokens of response intended by a model exceeds this value. Default is 500.
4) The **temperature**, a numeric vector, controls the variability/creativity in an LLM’s responses. Default is 0.7.
5) The **n**, a numeric vector, is only available for OpenAI GPT series. Please put in "1" if you use other LLMs. This argument specifies the number of responses for each trial. If n = 20, there will be 20 responses for each request. Note that, for multiple-trials-per-run design, this parameter must be set to 1 for avoiding branching conversations. The distinction between "n" and "Step" lies in their operation. With Step > 1, the package sends the request multiple times, receiving one response each time. Conversely, with n > 1, the package sends a single request but receives multiple responses for the request. Essentially, in an one-trial-per-run design, you can substitute Step with n for saving tokens, whereas in a multiple-trials-per-run design, Step is crucial for iteration.
6) The **checkToken**, a logical vector, determines if a token count check should be performed. When set to TRUE, this option initiates the upload of your experimental stimuli to the tokenizer server of this package for token counting; the default setting, however, is FALSE. It is important to note that your submitted stimuli are not retained on the server. They are promptly deleted after the necessary calculations are completed. The "checkToken" function generates varying reports tailored to your specific experimental design. For instance:

.

    One-trial-per-run design
            CheckItem          Values
    1	item numbers        1200
    2	max_token_numbers    137
    3	sum_token_numbers  95427

The "item numbers" shows how many items you have (the number of item* Step). The value of "max_token_numbers" indicates the max length of token number in the current experiment. It should not exceed the model’s input limits. The value of "sum_token_numbers" is the estimated token number for your whole experiment ((systemPrompt + token of each item + max_tokens) * trial, max_tokens is the allowed max length in reponse).

    Multiple-trials-per-run design
    Run    max_tokens_per_run
    1      756
    2      1016

In the report for a multiple-trials-per-run design, this package calculates the last trial of one run (containing all conversational history) as max token number, that is, (systemPrompt + max_tokens) * trial + previous conversation history+ token of last item; it then reports this number for each run. Please make sure that the max token per run should not exceed the LLM’s token limit.

</div>

<div id="run-the-experiment" class="section level3">

### 5\. Run the Experiment:

The `runExperiment` function is the execution phase of data collection. It initiates the interaction with an LLM based on the specified design and parameters, and iteratively collects responses to the stimuli.

    runExperiment(gptConfig, savePath = "./demo.xlsx")

    ## 
      |                                                                            
      |                                                                      |   0%[1] 1
      |==============                                                        |  20%[1] 2
      |============================                                          |  40%[1] 3
      |==========================================                            |  60%[1] 4
      |========================================================              |  80%[1] 5
      |======================================================================| 100%
    ## [1] "Done."

1) **gptConfig** is the configuration list object containing all the details of the experiment setup, including the system prompt, chosen model, maximum tokens, temperature, the number of responses and other parameters. This object is crafted in the preceding steps and encapsulates the operational blueprint of the experiment.
2) **savePath** is the file path where the experiment results will be saved. This should be an accessible directory on the user's machine with the appropriate write permissions. The ".xlsx " or ".csv " extension denotes that the output file is in the Excel/CSV format, suitable for further analysis or review.
When `runExperiment` is invoked, the package sends a prompt to the language model, captures the model’s output, and then moves on to the next stimulus as per the experiment design. 

</div>



