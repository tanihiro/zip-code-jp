# ZipCodeJp

A Ruby gem for manipulating JP postal codes.

## Installation

Add this line to your application's Gemfile:

    gem 'zip_code_jp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zip_code_jp

## Usage

    address = ZipCodeJp.find '102-0072'
    address.prefecture      # 東京都
    address.prefecture_kana # トウキョウト
    address.prefecture_code # 13
    address.city            # 千代田区
    address.city_kana       # チヨダク
    address.town            # 飯田橋
    address.town_kana       # イイダバシ
    address.zip_code        # 1020072

If more than one address corresponds

    addresses = ZipCodeJp.find '0790177'
    addresses.class # Array
    addresses.each do |address|
      address.zip_code # 0790177
    end

Update the JSON data of postal code

    ZipCodeJp.export_json

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
