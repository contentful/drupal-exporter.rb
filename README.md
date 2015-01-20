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
