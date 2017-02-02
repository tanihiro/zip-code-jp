# -*- coding: utf-8 -*-
require 'zip'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'nkf'
require 'yaml'

module ZipCodeJp
  class Export
    ZIP_URL_DOMAIN  = 'http://zipcloud.ibsnet.co.jp'

    private
    def self.to_hash(row)
      {
        :zip_code        => row[2],
        :prefecture      => NKF.nkf('-S -w', row[6]),
        :prefecture_kana => NKF.nkf('-S -w', row[3]),
        :city            => NKF.nkf('-S -w', row[7]),
        :city_kana       => NKF.nkf('-S -w', row[4]),
        :town            => NKF.nkf('-S -w', row[8]),
        :town_kana       => NKF.nkf('-S -w', row[5])
      }
    end

    def self.to_hash_office(row)
	 {
      :zip_code        => row[7],
      :prefecture      => NKF.nkf('-S -w', row[3]),
      :city            => NKF.nkf('-S -w', row[4]),
      :town            => NKF.nkf('-S -w', row[9]),
    }
  end



    private
    def self.zip_url
      html = Nokogiri::HTML(open(ZIP_URL_DOMAIN))
      url = html.css('[href^="/zipcodedata/download"]').last.attributes['href']

      "#{ZIP_URL_DOMAIN}#{url}"
    end

    private
    def self.zip_codes
      zip_codes = {}
      prefecture_codes = YAML.load(File.open("#{ZipCodeJp::DATA_DIR}/prefecture_code.yml"))
      Zip::File.open(open(zip_url).path) do |archives|
        archives.each do |a|
          CSV.parse(a.get_input_stream.read) do |row|
            h = to_hash(row)
            h[:prefecture_code] = prefecture_codes.invert[h[:prefecture]]
            first_prefix  = h[:zip_code].slice(0,3)
            second_prefix = h[:zip_code].slice(3,4)
            zip_codes[first_prefix] = {} unless zip_codes[first_prefix]

            if zip_codes[first_prefix][second_prefix] && !zip_codes[first_prefix][second_prefix].instance_of?(Array)
              zip_codes[first_prefix][second_prefix] = [zip_codes[first_prefix][second_prefix]]
            end

            if zip_codes[first_prefix][second_prefix].instance_of?(Array)
              zip_codes[first_prefix][second_prefix].push h
            else
              zip_codes[first_prefix] = zip_codes[first_prefix].merge({second_prefix => h})
            end

          end
        end
      end

	  Zip::File.open(open('http://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip').path) do |archives|
        archives.each do |a|
          CSV.parse(a.get_input_stream.read) do |row|
            h = to_hash(row)
            h[:prefecture_code] = prefecture_codes[h[:prefecture]]
            first_prefix  = h[:zip_code].slice(0,3)
            second_prefix = h[:zip_code].slice(3,4)
            zip_codes[first_prefix] = {} unless zip_codes[first_prefix]

            if zip_codes[first_prefix][second_prefix] && !zip_codes[first_prefix][second_prefix].instance_of?(Array)
              zip_codes[first_prefix][second_prefix] = [zip_codes[first_prefix][second_prefix]]
            end

            if zip_codes[first_prefix][second_prefix].instance_of?(Array)
              zip_codes[first_prefix][second_prefix].push h
            else
              zip_codes[first_prefix] = zip_codes[first_prefix].merge({second_prefix => h})
            end

          end
        end
      end

      zip_codes
    end

    def self.execute
      zip_codes().each do |prefix, value|
        file_path = "#{ZipCodeJp::DATA_DIR}/zip_code/#{prefix}.json"
        File.open(file_path, 'wb') do |file|
          file.write JSON.generate(value)
        end
      end
    end
  end
end
