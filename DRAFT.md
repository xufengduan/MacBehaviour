1. Introduction

Just as new aircraft designs aren't rushed into production but are instead meticulously tested in wind tunnel simulations, could the digital wind tunnels for psycholinguistic research be the language models of the future? The advent of large language models (LLMs) such as OpenAI's GPT series has engendered a transformative shift in computational linguistics, providing tools with unprecedented linguistic capabilities. Along with some open-source LLMs, these models, equipped with the ability to generate coherent and contextually relevant text, have become valuable proxies for understanding human language processing. Psycholinguistic experiments, traditionally conducted with human subjects, are increasingly leveraging the prowess of LLMs to simulate and study language behaviours. The predictive patterns of LLMs, while not identical to human cognition in all aspects so far, still offer a fertile ground for hypotheses generation and preliminary testing, providing a cost-effective and scalable alternative to early-stage language research for human subjects.

The use of LLMs in psycholinguistics also facilitates the replication of classic experiments, allowing researchers to observe whether LLMs exhibit behaviours like human-like linguistic phenomena, including priming effects, garden path sentences, and ambiguity resolution. This not only enriches our understanding of language but also contributes to the broader field of cognitive science and computer science, providing insights into the LLM’s performance in a specific domain (based on your task) and its underlying mechanisms of language understanding and production. However, the design, execution, and data collection stages of experiments with LLMs demand considerable programming expertise, access to computational resources, and familiarity with the models’ APIs, which can be daunting barriers for many researchers.

In response to these challenges, there is a clear need for an accessible, efficient, and user-friendly R package that streamlines the entire experimental process when interfacing with LLMs like GPT or open-source models in Huggingface. The envisioned R package, `MacBehaviour`, promises to fulfill this need, offering a suite of functions tailored for psycholinguistic experiments. 

2. Methods
---
Table 1. `MacBehaviour` R package functions briefly described

Function	Description
set_key	Authenticates the user with OpenAI using their API key.
read.xlsx	Loads experimental stimuli from an Excel file.
loadData	Prepares the stimuli data for the experiment.
experimentDesign	Defines the experiment setup based on the stimuli loaded.
preCheck	Configures experimental parameters prior to execution.
runExperiment	Executes the experiment and saves the results to an Excel file.

2.1. Installation and Setup
The `MacBehaviour` package operationalizes the interaction with OpenAI's GPT models(XX) and Huggingface models (XX) within the R environment, facilitating the conduct of psycholinguistic experiments. The installation of `MacBehaviour` is straightforward, researchers can install these packages using the Comprehensive R Archive Network (CRAN) as follows:

```r
install.package(MacBehaviour)
github install
```

Upon the successful installation, the libraries are then loaded into the current R session:

```r
library(MacBehaviour)
```

Subsequent to package loading, we need to verify the API from OpenAI/Huggingface for the experiment. The `set_key` function encapsulates the API key, maintaining security while providing access:

```r
set_key("YOUR_OPENAI_API_KEY", url = ‘’)
```
The `YOUR_OPENAI_API_KEY` argument is to be replaced with the researcher's personal OpenAI key, which grants authenticated access to the GPT models through the OpenAI API.

url is an argument to specify interface domain of the model you chose for the experiment. You can find the link at Huggingface: XXXX or OpenAI:XXXX

3.2. Load experimental stimuli
Before using this package, the researcher should prepare an Excel file/data frame containing the experimental stimuli. 

```r
df = read.xlsx("/path/to/excel/demo.xlsx")
```
The `read.xlsx` function from the `openxlsx` package reads the file, converting it into a data frame within R.

The Excel file/data frame should exhibit a structured format, defining columns for "Run", "Item", "Condition", and "Prompt", with each row representing a unique stimulus. This organization is pivotal for maintaining the integrity of the experimental design, ensuring each stimulus is correctly identified and presented as your experiment design during the experiment.

The process of loading experimental stimuli is a critical step in the `MacBehaviour` package workflow, serving as the foundation for subsequent experimental manipulation and data collection. To accurately represent the stimuli within the R environment, the `loadData` function is utilized, which translates the structured data from an Excel file/data frame into an organized data frame within R. This data frame is then employed to execute the experimental design and interface with the LLMs’ API:

```r
ExperimentItem = loadData(runList=df$Run, itemIDList=df$Item, conditionList=df$Condition, targetPrompt=df$Content)
```

Each argument of the `loadData` function maps to a specific column in the provided Excel spreadsheet, ensuring that the data's integrity is preserved and appropriately structured for the experiment's needs:

- **runList**: The `runList` argument corresponds to the "Run" column in the Excel file, which designates the index of the conversation with the model. This is akin to a "list" in a psychological experiment, wherein stimuli within a list—or "Run" in this context—are presented in a continuous conversation/run to the participant.

- **itemIDList**: The `itemIDList` argument refers to the "Item" column, indicating the item index of your stimuli. This numerical identifier serves as a reference for the researcher and does not influence the model's behavior or response. It is a label that allows for the tracking and organization of the stimuli throughout the experiment.

- **conditionList**: The `conditionList` represents the "Condition" column, which specifies the experimental condition associated with each stimulus. Similar to `itemIDList`, this is for the researcher's reference and does not interact with the model's operation. It could represent different languages or sentence structures in a translation experiment, for instance.

- **targetPrompt**: The `targetPrompt` argument maps to the "Content" column, which contains the actual prompts that will be presented to the model during the experiment. Each entry under this column is a unique prompt that the language model will process and respond to, forming the core of the experimental data collection.

In the context of the experimental design, `ExperimentItem` is a list generated by `loadData`, which includes all the necessary details for each stimulus as they are to be presented to the GPT model. The accuracy of `loadData` in mapping the Excel spreadsheet to the `ExperimentItem` list is paramount, as it ensures that each stimulus is precisely presented according to the experimental protocol, thereby guaranteeing the validity and reliability of the experimental results.

There are two examples to illustrate arguments in this function. The `MacBehaviour` R package is equipped to handle two primary experimental designs: Mulitple trials per Run and One trial per run. Each design has distinct characteristics and is suitable for different research questions.

3.2.1 Multiple Trials per Run

In the multiple trials per run design, multiple stimuli are presented to the model in a single conversation (or run). This simulates a scenario where a participant (in this case, the language model) is exposed to a series of stimuli in a sequence. This design can be particularly insightful for studying context effects, such as priming, where the response to a stimulus may be influenced by the preceding stimuli.

**Example:**
Imagine an experiment where the priming task is to complete preambles. The Excel file might be structured as follows for a single run:

Run	Item	Condition	Content
1	1	PO_inducing	The girl is crying and there is a toy in the room. So the boy gives a  toy to __.
1	1	Target	The girl is hungry and there are some cookies in the kitchen. So the mother gives __.
2	1	DO_inducing	The girl is crying and there is a toy in the room. So the boy gives the girl __.
2	1	Target	The girl is hungry and there are some cookies in the kitchen. So the mother gives __.


Following this the prompt for the Run 1 second trial of this experiment, the there are two roles in the context — user (stimuli) and assistant (participant).  

``` data
list(role = "user", content = " The girl is crying and there is a toy in the room. So the boy gives a  toy to __.") list(role = "assistant", content = "the girl") list(role = "user", content = " The girl is hungry and there are some cookies in the kitchen. So the mother gives __.")
```
In this case, the response "the girl" to a stimulus " The girl is crying and there is a toy in the room. So the boy gives a  toy to __." was provided as a part of current prompt. The prompt continued to show the current stimuli of Target condition " The girl is hungry and there are some cookies in the kitchen. So the mother gives __.") after the background information in this way.

In this design, more than one preamble will be presented in a single conversation (run). The language model would process the previous prompt along with the model’s response as a part of the prompt, which could lead to contextual influences where the second trial in Run 1 of “ So the mother gives __.” might be subtly affected by the prior prompt and answer.

 


3.2.2 One trial per run

The One trial per rundesign treats each translation task as a distinct event, separated from all others. This approach is akin to an experimental design where each stimulus is presented in isolation to avoid any context effects. For example, in a translation experiment where each run involves a single translation task. You won’t want to let the previous context affect the translation quality, so a desirable condition is that there is no continuity between runs.

**Example:**
Using the same set of English sentences intended for translation into multiple languages, the Excel file might appear as follows, where each translation is its own run:

Run	Item	Condition	Content
1	1	Chinese	Translate 'Hello, how are you?' into Chinese.
2	2	Chinese	Translate 'I love ice cream' into Chinese.
3	3	Chinese	Translate 'The sun is shining.' into Chinese.


In this structured approach, each sentence is given a unique run number, indicating that it is to be presented in a separate conversation with the model. This eliminates the potential for one task to influence the translation of another, ensuring that each item is evaluated independently.
 

These designs offer researchers the flexibility to structure their experiments in a way that best suits their hypothesis. Whether the goal is to examine cumulative effects of language exposure or to assess discrete translation capabilities without contextual bias, the `MacBehaviour` R package can accommodate the necessary experimental setup.



3.3. Experimental Design
The experimental design phase is critical, enabling the researcher to delineate the structure and sequence of the experimental runs. The `experimentDesign` function in `MacBehaviour` defines the experiment:

```r
Design = experimentDesign(ExperimentItem, Step=1, random = F)
```

In the context of `Step`, if one wishes to collect multiple data points for each item, this argument specifies the number of sessions that the stimuli are to be presented to the model. A `random` argument is available to randomize the order of stimuli presentation within a run (conversation), so it should remain false (`F`) for experiments that are one-trial per run design.

3.4. Experimental Parameters
The experimental parameters are configured to guide the behavior of the model during the experiment. The `preCheck` function establishes these parameters:

```r
gptConfig = preCheck(Design, systemPrompt="You are a participant in a psycholinguistic experiment", model="gpt-3.5-turbo", max_tokens=500, temperature=0.7, n=1)
```
‘Design’ is the output of experimentDesign function.

The `systemPrompt` offers a task instruction to the model analogous to the instructions given in a human psychological experiment. Should one wish to convey the instructions to the model through the trial prompt, this parameter can be left blank here or say some rules in general: “You are a participant in psycholinguistics experiment, please follow the task instruction carefully.”

Model selection through the `model` argument ensures the experiment is conducted using the desired GPT variant, taking into account the computational cost and the capabilities of the chosen model. 

The `max_tokens` parameter caps the length of the model's response, a necessity to align with the constraints of psycholinguistic experimental design, 

`temperature` controls the variability/creativity in the model's responses, akin to controlling for the predictability in a human subject's responses. 

`n`  the response numbers for each trial. It is very useful for on trial per run design. If n =20, you will have 20 response per one request.  Please note that this parameter should be 1 in the multiple trials per run design. We do not support multiple reponses for each trial in a multiple trials per run design, which would result in multiple branches of conversation.

Other parameters

3.5 Execution

The `runExperiment` function is the execution phase of data collection. It initiates the conversation with the language model based on the specified design and parameters, and iteratively collects responses to the stimuli.

```{r}
runExperiment(gptConfig, savePath = "./demo.xlsx")
```

**Arguments:**

- `gptConfig`: This is the configuration list object containing all the details of the experiment setup, including the system prompt, chosen model, maximum tokens, temperature, the number of responses and other parameters. This object is crafted in the preceding steps and encapsulates the operational blueprint of the experiment.
  
- `savePath`: The file path where the experiment results will be saved. This should be an accessible directory on the user's machine with the appropriate write permissions. The `.xlsx` extension denotes that the output file is in the Excel format, suitable for further analysis or review.

When `runExperiment` is invoked, the package commences sending the prompts to the language model, capturing the responses, and then moves onto the next item as per the experiment design. 

3.6 Output

Upon the completion of the experiment, the responses are compiled into an Excel file. This file consists of multiple columns detailing each run, item, condition, stimulus, and the corresponding response from the model. Additional columns record metadata such as response time, token count, and any error messages if encountered.

**Output File Structure:**

The output Excel file typically has the following columns:

- `Run`: Denotes the conversation index.
- `ItemID`: Indicates the Item number.
- `Condition`: Details the condition under which the item was presented.
- `Prompt`: Contains the original stimulus content sent to the model.
- `Response`: The model's response to the stimulus.
- `N`: The response index of a single request.
- `Trial`: The turn index of a conversation.
- `Message`: the actual prompt we send to LLMs.
The Excel format is particularly friendly for researchers who may wish to perform additional data manipulation or visualization within spreadsheet software or import the data into statistical software packages for further analysis.


4. Discussion

The MacBehaviour R package offers an integrated solution for conducting experiments with LLMs. It enables efficient workflows through easy interaction with the OpenAI/ Huggingface API and streamlines the process with its built-in functions.  While other scripts exist for similar purposes, `MacBehaviour` distinguishes itself through its R-based environment, which is well-suited for statistical analysis and data visualization in behavioral research. This contrasts with some Python-based tools, which, although powerful, may not be aligned with the statistical requirements of psycholinguistic research. `MacBehaviour` has a wide array of potential applications beyond psycholinguistic studies. It could be utilized in the fields of cognitive psychology, linguistics, artificial intelligence, and machine learning, where understanding the intricacies of language comprehension and production is essential. The package can aid in tasks such as the assessment of language models' comprehension abilities.

As it currently stands, the package is specifically tailored for the OpenAI and Huggingface models, which might limit its use with other emerging language models or APIs. Additionally, the cost associated with API calls to OpenAI/Huggingface could be a limiting factor for some researchers.

Future updates could aim to broaden the scope of `MacBehaviour` to include compatibility with a wider range of models and APIs, thereby expanding its utility. Improvements could also be made to include a more sophisticated error handling and provide more response like token probability etc. Another avenue for enhancement is the inclusion of more complex experimental paradigms, such as those requiring adaptive designs where the stimuli presented are contingent on prior responses.

5. Conclusion

In conclusion, the `MacBehaviour` R package serves as a methodological toolkit available for psycholinguistic research for LLMs. It facilities researchers to design/replicate experiment and collect LLM’s verbal response. 
