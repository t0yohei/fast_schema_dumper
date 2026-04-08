# frozen_string_literal: true

require "test_helper"
require "fast_schema_dumper/fast_dumper"

class FastSchemaDumperTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FastSchemaDumper::VERSION
  end

  def test_format_generated_column
    dumper = FastSchemaDumper::SchemaDumper.new
    column = {
      'COLUMN_NAME' => 'active_unique_key',
      'DATA_TYPE' => 'int',
      'COLUMN_TYPE' => 'int',
      'EXTRA' => 'STORED GENERATED',
      'GENERATION_EXPRESSION' => 'if((`deleted_at` is null),1,NULL)',
      'COLUMN_COMMENT' => '',
      'IS_NULLABLE' => 'YES'
    }

    actual = dumper.send(:format_column, column)

    assert_equal(
      't.virtual "active_unique_key", type: :integer, as: "if((`deleted_at` is null),1,NULL)", stored: true',
      actual
    )
  end

  def test_format_generated_column_with_comment
    dumper = FastSchemaDumper::SchemaDumper.new
    column = {
      'COLUMN_NAME' => 'full_name',
      'DATA_TYPE' => 'varchar',
      'COLUMN_TYPE' => 'varchar(255)',
      'EXTRA' => 'VIRTUAL GENERATED',
      'GENERATION_EXPRESSION' => 'concat(`first_name`,`last_name`)',
      'COLUMN_COMMENT' => 'generated name',
      'IS_NULLABLE' => 'YES'
    }

    actual = dumper.send(:format_column, column)

    assert_equal(
      't.virtual "full_name", type: :string, as: "concat(`first_name`,`last_name`)", comment: "generated name"',
      actual
    )
  end
end
