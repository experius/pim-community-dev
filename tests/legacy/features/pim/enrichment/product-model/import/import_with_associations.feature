Feature: Import product models with associations
  In order to use existing product model information
  As a product manager
  I need to be able to import product models with associations

  Background:
    Given the "catalog_modeling" catalog configuration

  Scenario: Successfully import a csv file of product models with associations with comparison enabled
    And the following CSV file to import:
      """
      code;family_variant;image;UPSELL-products;UPSELL-groups;UPSELL-product_models
      model-bikers-jacket;clothing_material_size;;watch,1111111304;related;model-braided-hat
      model-tshirt-unique-size;clothing_material_size;;1111111304;;bad_model
      model-tshirt-unique-size;clothing_material_size;;watch;;model-braided-hat
      """
    When the product models are imported via the job csv_catalog_modeling_product_model_import with options:
      | enabledComparison | yes |
    Then the product model "model-bikers-jacket" should have the following associations:
      | type   | products         |groups  |product_models    |
      | UPSELL | watch,1111111304 |related |model-braided-hat |
    And the product model "model-tshirt-unique-size" should have the following associations:
      | type   | products |
      | UPSELL | watch    |

  Scenario: Successfully import a csv file of product models with associations with comparison disabled
    And the following CSV file to import:
      """
      code;family_variant;image;UPSELL-products;UPSELL-groups;UPSELL-product_models
      model-bikers-jacket;clothing_material_size;;watch,1111111304;related;model-braided-hat
      model-tshirt-unique-size;clothing_material_size;;1111111304;;bad_model
      model-tshirt-unique-size;clothing_material_size;;watch;;model-braided-hat
      """
    When the product models are imported via the job csv_catalog_modeling_product_model_import with options:
      | enabledComparison | no |
    Then the product model "model-bikers-jacket" should have the following associations:
      | type   | products         |groups  |product_models    |
      | UPSELL | watch,1111111304 |related |model-braided-hat |
    And the product model "model-tshirt-unique-size" should have the following associations:
      | type   | products |
      | UPSELL | watch    |

  Scenario: Successfully import a csv file of product models with association to himself
    And the following CSV file to import:
      """
      code;family_variant;image;UPSELL-products;UPSELL-groups;UPSELL-product_models
      model-bikers-jacket;clothing_material_size;;watch;;model-bikers-jacket,model-braided-hat
      """
    When the product models are imported via the job csv_catalog_modeling_product_model_import with options:
      | enabledComparison | yes |
    Then the product model "model-bikers-jacket" should have the following associations:
      | type   | products |product_models                        |
      | UPSELL | watch    |model-bikers-jacket,model-braided-hat |

  Scenario: Successfully import a csv file of sub product models with associations
    And the following CSV file to import:
      """
      code;family_variant;image;UPSELL-products
      plain;clothing_material_size;;watch
      plain_red;clothing_material_size;;1111111304
      """
    And the product models are imported via the job csv_catalog_modeling_product_model_import with options:
      | enabledComparison | yes |
    Then the product model "plain" should have the following associations:
      | type   | products |
      | UPSELL | watch    |
    And the product model "plain_red" should have the following associations:
      | type   | products   |
      | UPSELL | watch,1111111304 |
