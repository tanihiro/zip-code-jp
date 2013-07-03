require 'zip_code_jp/export'

module ZipCodeJp

  module_function
  def export_json
    ZipCodeJp::Export.execute
  end

  def find
  end
end
