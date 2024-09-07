# How to Obtain an API Key for MacBehaviour

## Introduction

To use **MacBehaviour** with models like OpenAI GPT, Hugging Face models, or other supported LLMs (Large Language Models), you will need to provide an API key. The `api_key` argument is **required** for authenticated access to the models.

If you are using a self-hosted model, please set the `api_key` argument to `"NA"`. However, for all other platforms, an API key from the respective provider is necessary.

### Important:
- **API keys** are personal and tied to your account with OpenAI, Hugging Face, or other companies.
- **Costs**: Model inference requires significant computational resources. **Users must pay** for access to these resources.

## How to Obtain an OpenAI API Key

If you plan to use models from **OpenAI** (e.g., GPT-4), follow these steps to obtain your API key:

1. Go to the [OpenAI platform](https://platform.openai.com/).
2. **Sign up** for an account if you do not have one already.
3. Once logged in, navigate to your **account settings**.
4. In the account settings, you will find an option to **generate a personal API key**. 
5. Copy this key and use it in the `api_key` argument when calling the `setKey()` function.

### Costs:
- **OpenAI API access is not free**. You will need to pay for model inference, and pricing details can be found [here](https://openai.com/pricing).
- Ensure you are aware of the potential costs before using the API for extensive experiments.

## How to Obtain a Hugging Face API Key

For models hosted on **Hugging Face** (e.g., Llama 3.1), follow these steps:

1. Go to the [Hugging Face platform](https://huggingface.co/).
2. **Sign up** for an account if you do not already have one.
3. After logging in, go to your **account settings**.
4. In the settings, look for the **access token** section and **generate a new token**.
5. Copy this token and use it as your API key in the `api_key` argument.

### Costs:
- Hugging Face provides both **free** and **paid** tiers for model inference, depending on the computational requirements.
- Pricing details for Hugging Face model inference are available [here](https://huggingface.co/blog/inference-pro).
- Be mindful that extensive or high-resource usage will incur costs.

