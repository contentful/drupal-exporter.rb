Drupal to Contentful Exporter
=================

## Description
This tool will extract the following content from a Drupal database dump file:

* Content types (Blog, Article, Page, Custom content types)
* Comments
* Tags
* Vocabularies
* Users

## Setup

Create settings YML file (e.g. settings.yml) to define all required parameters.
Assuming we are going to work with MySQL, SQlite or PostgreSQL database, you must define credentials to connect Drupal database.
Example of connection with MySQL database "test_import"

```yml
adapter: mysql2
user: username
host: localhost
database: drupal_database_name
password: secret_password
```

**Available Adapters**

```
PostgreSQL => postgres
MySQL => mysql2
SQlite => sqlite
```

#### Content types

For proper mapping of entries from Drupal content types, the name of contentful content types must be identical as Drupal content types name.

Example:
```
Drupal name of content type => 'Blog'
Contentful name of content type => 'Blog'
```

#### Comments and Tags
These content types are exported from Drupal database by default and assigned to every content type. There is no need to specify them in content type structure.

There will be saved with following api fields id:
```
Comments => 'comments'
Tags => 'tags'
```

#### Content type's custom tags

If you want to add tags that you define in custom table, you need to specify them by adding addition parameter in hash:
```
        "term_tagging":{
            "table": "field_term_tagging"
        }
```
#### Boolean
To map columns of boolean values, you need to create YML file ( e.g. boolean_columns.yml ) and define mechanic names of boolean columns.

Example:
```yml
- field_if_content_type
- field_boolean
```
In settings.yml file define path to ```drupal_boolean_columns``` file.

```yml
drupal_boolean_columns: PATH_TO_YML_FILE
```
#### Files & Images

It is not possible to import imagers / files from a local server, because to create an Asset the required parameters the URL to the source.
For this purpose, you must define the ```drupal_base_url``` in the settings.yml file.

```yml
drupal_base_url: http://example_hostname.com
```

### Mapping structure

Create JSON file with content types structure:

```
    "mechanic_name_of_content_type" : {
    "contentful_api_fiel_idd" : "column_mechanic_name",
    "contentful_api_field_id2" : "column_mechanic_name2",
    "contentful_api_field_id3" : "column_mechanic_name23"
        }
```

Example structure:

```
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

In settings.yml file define path to ```drupal_content_types_json``` file.

```yml
drupal_content_types_json: PATH_TO_JSON_FILE
```

#### Example structure of settings.yml file

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
```
contentful-importer --config-file settings.yml --exporter drupal --export-json
```
