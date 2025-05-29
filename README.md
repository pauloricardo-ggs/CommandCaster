# CommandCaster

CommandCaster is a macOS application for developers that simplifies the management of variables in the **AWS Parameter Store**. This project was created as a learning tool while I'm honing my skills in Swift. Future updates will introduce new features and optimizations to enhance the user experience and expand the application's capabilities.

## AWS Credentials Configuration

CommandCaster uses the **AWS SDK** to access the AWS Parameter Store. This SDK requires access credentials configured as environment variables, which must be specified in the AWS `credentials` and `config` files.

> **Note**: CommandCaster **does not directly access** these credentials. The AWS SDK reads them to manage secure access to AWS services.

### How to Set Up Access

1. **Create the Configuration Folder and Files**:
   - In your home directory, navigate to the `.aws` folder. If it doesn’t exist, you can create it by running:
     ```bash
     mkdir -p ~/.aws
     ```

2. **Configure the Credentials File**:
   - In the `~/.aws` directory, create or edit the `credentials` file to add the access keys (access key and secret key) for your AWS account.
   - The `credentials` file should follow the format below:
     ```ini
     [default]
     aws_access_key_id = YOUR_ACCESS_KEY
     aws_secret_access_key = YOUR_SECRET_KEY
     ```

3. **Configure the Config File**:
   - In the same `~/.aws` directory, create or edit the `config` file to set the default region that CommandCaster will use to access the Parameter Store.
   - The `config` file should follow this format:
     ```ini
     [default]
     region = us-east-1
     ```
   - Replace `us-east-1` with the region where your AWS Parameter Store variables are stored.

### Complete Example

After configuration, the structure of the `~/.aws` folder should look like this:

```
~/.aws/
├── config         # Define the region
└── credentials    # Contains the access keys
```

### Important Notes
- **Profile Switching**: If you want to use different AWS profiles, you can set up additional sections in the `credentials` and `config` files, such as `[profile1]`, `[profile2]`.
- **Note**: Currently, CommandCaster only uses the `default` profile. Profile management will be added in a future update, allowing you to select custom profiles directly within the app.

## Features

- **Variable Management**: View, edit, and organize variables stored in the AWS Parameter Store.

### Upcoming Features

- **Docker Compose Container Management**: In a future update, CommandCaster will include support for managing containers using Docker Compose. This feature will facilitate running containers for projects with multiple services and databases across different environments (local, dev, hg). This functionality will be especially useful for developers needing a simplified way to run databases and services for testing in various contexts.

## Contact

For questions or suggestions, please reach out via email at: [contact@pauloricardo.dev](mailto:contact@pauloricardo.dev)
