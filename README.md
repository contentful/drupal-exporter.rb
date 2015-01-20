Drupal to Contentful Exporter
=================

## Description
This tool will extract the following content from a Drupal database dump file:

* Content types (Blog, Article, Page, Custom content types)
* Comments
* Tags
* Vocabularies
* Users

## Setup ##

Create settings a YML file (e.g. settings.yml) to define all required parameters.
Assuming we are going to work with either MySQL, SQLite or a PostgreSQL database, you must define credentials to connect Drupal database.
An example configuration for connecting with a MySQL database named "test_import":

```yml
adapter: mysql2
user: username
host: localhost
database: drupal_database_name
password: secret_password
```

### Available Adapters ###

* PostgreSQL => postgres
* MySQL => mysql2
* SQlite => sqlite


## Content Types ##

To be able to properly map the Drupal content types to the Contentful content types they must be identical by name.

Example:

```
Drupal name of content type => 'Blog'
Contentful name of content type => 'Blog'
```

## Comments and Tags ##

These content types are exported from the Drupal database by default and assigned to every content type. There is no need to specify them in the content type structure.

They will be saved with the following api field ids:
```
Comments => 'comments'
Tags => 'tags'
```

### Custom tag content types ###

If you want to add tags that you define in a custom table, you need to specify them by adding an addition parameter to the hash:
```
"term_tagging":{
    "table": "field_term_tagging"
}
```

### Booleans ###

To map columns of boolean values, you need to create YML file ( e.g. boolean_columns.yml ) and define mechanic names of boolean columns.

Example:
```yml
- field_if_content_type
- field_boolean
```

The path to the  `drupal_boolean_columns` file is defined in the settings.yml.

```yml
drupal_boolean_columns: PATH_TO_YML_FILE
```

### Assets & Images ###

Your files and assets need to be available and accessible through the internet.
For this purpose, you must define the `drupal_base_url` in the settings.yml file so that the importer will be able to create them.

```yml
drupal_base_url: http://example_hostname.com
```

### Mapping structure ###

Create JSON file with content types structure:

```javascript
"mechanic_name_of_content_type" : {
"contentful_api_fiel_idd" : "column_mechanic_name",
"contentful_api_field_id2" : "column_mechanic_name2",
"contentful_api_field_id3" : "column_mechanic_name23"
}
```

Example structure:

```javascript
{
    "article": {
        "body": "body",
        "image": "field_image"
    },
    "page": {
        "body": "body"
    },
    "blog": {
        "body": "body"
    },
    "content_type": {
        "body": "body",
        "age": "field_age",
        "if_content_type": "field_if_content_type",
        "name": "field_first_name"
    }
}
```

In settings.yml file define path to the `drupal_content_types_json` file.

```yml
drupal_content_types_json: PATH_TO_JSON_FILE
```

### Example settings.yml file ###

```yml
data_dir: /tmp/data

#Connecting to a database
adapter: mysql2
host: localhost
database: database_name
user: username
password: password

# Drupal
drupal_content_types_json: PATH_TO_FILE/drupal_content_types.json
drupal_boolean_columns: PATH_TO_FILE/boolean_columns.yml
drupal_base_url: http://example_hostname.com
```

Command to extract data:

```bash
drupal-exporter --config-file settings.yml --extract-to-json
```


## Step by step

1. Create a YAML file with the required parameters (eg. `settings.yml`):

    ```yml
    # PATH TO ALL DATA
    data_dir: /tmp/data

    # CONNECTING TO A DATABASE
    adapter: mysql2
    host: localhost
    database: drupal
    user: szpryc
    password: root

    # DRUPAL SETTINGS
    drupal_content_types_json: drupal_settings/drupal_content_types.json
    drupal_boolean_columns: drupal_settings/boolean_columns.yml
    drupal_base_url: http://example_hostname.com

    # CONVERT CONTENTFUL MODEL TO CONTENTFUL IMPORT STRUCTURE
    content_model_json: PATH_TO_CONTENTFUL_MODEL_JSON_FILE/contentful_model.json
    converted_model_dir: PATH_WHERE_CONVERTED_CONTENT_MODEL_WILL_BE_SAVED/contentful_structure.json

    contentful_structure_dir: PATH_TO_CONTENTFUL_STRUCUTRE_JSON_FILE/contentful_structure.json
    ```
2. (Not required to extract data). Create the contentful_structure.json. First you need to create a content model using the [Contentful web application](www.contentful.com). Then you can download the content model using the content management api and use the content model for the import:

       ```bash
        curl -X GET \
             -H 'Authorization: Bearer ACCESS_TOKEN' \
             'https://api.contentful.com/spaces/SPACE_ID/content_types' > contentful_model.json
       ```

       It will create `contentful_model.json` file, which you need to transform into the `contentful_structure.json` using:

       ```bash
        drupal-exporter --config-file settings.yml --convert-content-model-to-json
       ```

       The converted content model will be saved as JSON file in the `converted_model_dir` path.

       Now you can generate content types JSON files.

       ```bash
       drupal-exporter --config-file settings.yml  --create-contentful-model-from-json
       ```
       It will create the content types JSON files which represent your content structure for the import.

3. Create the `drupal_content_types.json` file. This file contains the mapped structure of your database.

    Mapping structure:

    ```javascript
        mechanic_name_of_content_type : {
            contentful_api_field_1 : column_mechanic_name_1,
            contentful_api_field_2: column_mechanic_name_2,
            contentful_api_field_3 : column_mechanic_name_3
        }
    ```

    You can find a sample mapping file in the `drupal_settings/drupal_content_types.json` directory.

4. (Optional). Boolean values. Sequel converts boolean values `0,1`, stored in the database only when the field is TINYINT(1) type.
    To map the value of `0,1` to `false, true`, you have to specify the column names in the yaml file (eg. `boolean_columns.yml`) and
    specify the path to this file in the `settings.yml` file, parameter `drupal_boolean_columns`

    Example:

    ```yml
    - field_if_content_type
    - field_boolean
    ```
5. Extract the content from the database and generate the JSON files for the import:

    ```bash
    drupal-exporter --config-file settings.yml --extract-to-json
    ```
    It will _only_ extract the content and store it as JSON files, nothing will be uploaded yet.

6. Use the [contentful-importer](https://github.com/contentful/generic-importer.rb) to import the content to [contentful.com](https://www.contentful.com)


