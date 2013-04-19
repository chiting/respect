require "test_helper"

class ObjectDefTest < Test::Unit::TestCase

  def test_object_schema_definition_accept_integer
    s = Respect::ObjectSchema.define do |s|
      s.integer "test", equal_to: 15
      s.optionals do |s|
        s.integer "opt", equal_to: 43
      end
    end
    assert s.validate?({ "test" => "15", "opt" => "43" })
    assert s.validate?({ "test" => 15, "opt" => 43 })
  end

  def test_object_schema_definition_accept_null
    s = Respect::ObjectSchema.define do |s|
      s.null "test"
      s.optionals do |s|
        s.null "opt"
      end
    end
    assert s.validate?({ "test" => "null", "opt" => "null" })
    assert s.validate?({ "test" => nil, "opt" => nil })
  end

  def test_object_schema_definition_accept_float
    s = Respect::ObjectSchema.define do |s|
      s.float "test", equal_to: 1.5
      s.optionals do |s|
        s.float "opt", equal_to: 4.3
      end
    end
    assert s.validate?({ "test" => "1.5", "opt" => "4.3" })
    assert s.validate?({ "test" => 1.5, "opt" => 4.3 })
  end

  def test_object_schema_definition_accept_boolean
    s = Respect::ObjectSchema.define do |s|
      s.boolean "test", equal_to: false
      s.optionals do |s|
        s.boolean "opt", equal_to: false
      end
    end
    assert s.validate?({ "test" => "false", "opt" => "false" })
    assert s.validate?({ "test" => false, "opt" => false })
  end

  def test_object_schema_definition_accept_array
    s = Respect::ObjectSchema.define do |s|
      s.array "test"
      s.optionals do |s|
        s.array "opt"
      end
    end
    assert s.validate?({ "test" => [], "opt" => [] })
  end

  def test_block_must_take_one_arg
    assert_raise(ArgumentError) do
      s = Respect::ObjectSchema.define do |s, a|
      end
    end
    assert_raise(ArgumentError) do
      s = Respect::ObjectSchema.define do
      end
    end
  end

  def test_cannot_overwrite_property
    assert_raise(Respect::InvalidSchemaError) do
      Respect::ObjectSchema.define do |s|
        s.integer "id", equal_to: 42
        s.integer "id", equal_to: 51
      end
    end
  end

  def test_extra_properties_overwrite_expected_ones
    assert_raise(Respect::InvalidSchemaError) do
      Respect::ObjectSchema.define(strict: true) do |s|
        s.integer "test", equal_to: 42
        s.optionals do |s|
          s.integer "test", equal_to: 51
        end
      end
    end
  end

  def test_object_scope_accept_options
    s = Respect::ObjectSchema.define do |s|
      s.object "test", strict: true do |s|
        s.integer "test", equal_to: 42
      end
    end
    assert s["test"].options[:strict]
  end

end
