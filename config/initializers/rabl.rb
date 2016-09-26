require 'rabl'

module Rabl
  class Configuration
    attr_accessor :force_iso_dates
  end

  class Builder
    def to_hash(object = nil, settings = {}, options = {})
      @_object = object           if object
      @options.merge!(options)    if options
      @settings.merge!(settings)  if settings

      cache_results do
        @_result = {}

        # Merges directly into @_result
        compile_settings(:attributes)

        merge_engines_into_result

        # Merges directly into @_result
        compile_settings(:node)

        replace_nil_values          if Rabl.configuration.replace_nil_values_with_empty_strings
        replace_empty_string_values if Rabl.configuration.replace_empty_string_values_with_nil_values
        remove_nil_values           if Rabl.configuration.exclude_nil_values
        force_iso_dates             if Rabl.configuration.force_iso_dates

        result = @_result
        result = { @options[:root_name] => result } if @options[:root_name].present?
        result
      end
    end

    protected
      def force_iso_dates
        @_result = @_result.inject({}) do |new_hash, (k, v)|
          new_hash[k] = v.respond_to?(:iso8601) ? v.iso8601 : v
          new_hash
        end
      end
  end
end

Rabl.configure do |config|
  config.include_json_root = true
  config.include_child_root = true
  config.force_iso_dates = true
end
