# Remote config

A gem for managing feature and release flags in the backend and providing them remotely to a front-end.

## Usage

### Feature Flagging

Flagging allows checking of config values and doing different things based on their boolean value.

By including the flagging module you'll have access to the following methods:

```rb
include RemoteConfig::Flagging
```

```rb
caffeinate if feature_enabled? "coffee.caffeinated"
```

```rb
feature_enabled? "coffee.caffeinated" do
  caffeinate
end
```

The `RemoteConfig::Flagging` module is included into the rails route mapper so you can use flagging at route setup. This allows the deployment of unreleased endpoints that aren't routable until they are released.

```rb
routes do
  feature_enabled? "coffee_ordering" do
    resource :coffee
  end
end
```

### Release flags

Release flags work with the same syntax (replace `feature?` with `released?`), however instead of checking for boolean truthfulness, the value of the falg corresponds to a stage that it is released to. The `released?` method will then be checking if the current environment is in that release stage and returning true if so.

For example, if your configured release stages are:
```rb
RemoteConfig.configure do |config|
  config.release_stages = {
    production:  %s[production qa dev development],
    qa:          %s[qa dev development],
    development: %s[dev development]
  }
```

Then the following values are returned:

|             | development | uat   | production |
| ----------- | ----------- | ----- | ---------- |
| dev         | true        | true  | true       |
| development | true        | true  | true       |
| qa          | false       | true  | true       |
| production  | false       | false | true       |

*Current environments down the left VS the release stages along the top.*

Alternatively, if you wanted to release to specific environments instead of progressing through them, you can return an array of the exact environment(s) that you want it released on.

e.g. if the value is `[:qa]`, them it'll be `false` on development, dev and production, while true on qa.

By including the flagging module you'll have access to the following methods:

```rb
include RemoteConfig::Flagging
```

```rb
prompt_for_coffee_ordering if released? "coffee_ordering.cta"
```

```rb
released? "coffee_ordering.cta" do
  prompt_for_coffee_ordering
end
```

### Adapters

Where the feature and release flags are sorted from depends on what adapter is used. Currently, the only adapater is the `RemoteConfig::Adapters::RubyConfigAdapter`, which sources from a local YML file using the [Config](https://github.com/rubyconfig/config) gem.

By default the feature flagging looks for values under under `features` and release flagging looks for values under `releases`.

If you want to nest a flag under another, for example, you have a `coffee_ordering` release flag and you want to add a `coffee_ordernig.pre_pay` release flag. Then you can nest the new flag under the old one and add a `_` key underneath it for it's own value, e.g:

```yml
releases:
  coffee_ordering:
    _: uat
    pre_pay: development

```

An example `app/config/settings.yml` might look like:

```yml
releases:
  loyalty: uat
  coffee_ordering:
    _: production
    pre_pay: production
    v2:
      _: uat
      pre_pay: development
    v3:
      _: development

features:
  pay_in_car: true
```

NOTE: it may be useful to split out your releases and features YML into different files and load them in.

`app/config/releases.yml`
`app/config/features.yml`

TODO: provide ruby snippet of how to set this up in the initializers

