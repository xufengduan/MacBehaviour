# How to Obtain an API Key for MacBehaviour

## Introduction

To use **MacBehaviour** with models like OpenAI GPT, Hugging Face models, or other supported LLMs (Large Language Models), you will need to provide an API key. The `api_key` argument is **required** for authenticated access to the models.

If you are using a self-hosted model, please set the `api_key` argument to `"NA"`. However, for all other platforms, an API key from the respective provider is necessary.

### Important:
- **API keys** are personal and tied to your account with OpenAI, Hugging Face, or other companies.
- **Costs**: Model inference requires significant computational resources. **Users must pay** for access to these resources.

## How to Obtain a Hugging Face API Key

For models hosted on **Hugging Face** (e.g., Llama 3.1), follow these steps:

1. Go to the [Hugging Face platform](https://huggingface.co/).
2. **Sign up** for an account if you don't have one already. You may receive a verification email to complete your registration.
3. After logging in, click on your profile picture in the top right corner and go to your **settings**.
4. In the settings, find the **access token** section and **create a new token**.
5. Select `write` for the `Token type`, enter a name (e.g., testing), and click **create token**.
6. Copy this token and use it as your API key in the `api_key` argument.

### Costs:
- Hugging Face provides both **free** (e.g.,google/gemma-2-2b-it)and **paid** (e.g., meta-llama/Meta-Llama-3.1-8B-Instruct) tiers for model inference, depending on the computational requirements.
- Pricing details for Hugging Face model inference are available [here](https://huggingface.co/blog/inference-pro).
- You can <a href = "https://huggingface.co/settings/billing/subscription">subscribe PRO <a> for access to more advanced models

## How to Obtain an OpenAI API Key

To use models from **OpenAI** (e.g., GPT-4), follow these steps to get your API key:

1. Visit the [OpenAI platform](https://platform.openai.com/).
2. **Sign up** for an account if you don't have one.
3. After logging in, go to your **account settings**.
4. Set up your <a href ="https://platform.openai.com/settings/organization/billing/overview">payment</a> before using the API.
5. In the **Dashboard**, click on **API keys**, then select the option to **create a new secret key**.
6. Copy this key and use it as the `api_key` argument when calling the `setKey()` function.

### Costs:
- **OpenAI API access is not free**. You will need to pay for model inference, and pricing details can be found [here](https://openai.com/pricing).
- Ensure you are aware of the potential costs before using the API for extensive experiments.



