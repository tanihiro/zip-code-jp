# Zip::Code::Jp

A Ruby gem for manipulating JP postal codes.

## Installation

Add this line to your application's Gemfile:

    gem 'zip-code-jp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zip-code-jp

## Usage

    address = ZipCodeJp.find '102-0072'
    address.prefecture # 東京都
    address.prefecture_kana # トウキョウト
    address.prefecture_code # 13
    address.city # 千代田区
    address.city_kana # チヨダク
    address.town # 飯田橋
    address.town_name # イイダバシ
    address.zip_code # 1020072

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
