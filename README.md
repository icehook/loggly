# Loggly

[Loggly](www.loggly.com) API client for the Ruby programming language.

## Installation

Add this line to your application's Gemfile:

    gem 'loggly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install loggly

# Usage

## Connect

Simple connection method for Loggly authorization.

#### Required Connections Parameters:

    params = { :uri => "http://<account>.loggly.com",
               :username => <username>,
               :password => <password> }

#### Connect:

Authorize the Loggly API with `Loggy.connect(params)`

## Search

The Loggly API provides a simple interface to perform searches.

#### Single Field

The query `:q => { :'loggly.tag' => "bar" }` outputs to `loggly.tag:bar`

#### Multiple Fields

There are multiple methods for performing more complex searches.

##### AND Method Only, for now

    :q => {
      :'loggly.tag' => "bar",
      :'other.loggly.tag' => "baz"
    }

outputs to `loggly.tags:bar AND other.loggly.tags:baz`


#### Interfacing with API:

`Loggly::Event.all(:q => { :'loggly.tags' => "bar" })` returns an array of events.

### Search Endpoint Parameters:

* `:q` - optional - query string. Defaults to `"*"`.
* `:from` - optional - Start time for the search. Defaults to `-24h`.
* `:until` - optional - End time for the search. Defaults to `now`.
* `:order` - optional - Direction of results returned, either `asc` or `desc`. Defaults to `desc`.
* `:per_page` - optional - Number of rows returned by search. Defaults to `25`.

Check the official [Loggy documentation](https://www.loggly.com/docs/api-retrieving-data/) for more assistance.

## Events

Each Event has a **Response** and **attributes** that match the Loggly fields.

### Response

     {:total_events=>3292470,
      :page=>0,
      :events=>
      [{:tags=>["chipper", "frontend"],
        :timestamp => 1377431712208,
        :logmsg => "{\timestamp\: \13-08-25 11:55:12,208191\, \baremsg\: \Alert is due to run\}"",
          :event=>
          {:syslog=>
            {:priority=>142,
             :timestamp=>"2013-08-25T11:55:12.208596+00:00",
             :host=>"frontend01",
             :severity=>"Informational",
             :facility=>"local use 1"
            },
            :json=>
              {:timestamp=>13-08-25 11:55:12,208191,
               :baremsg=>"is due to run",
               :level=>"INFO"
              }
          },
          :logtypes=>["syslog", "json"],
          :id=>"c693c674-0d7d-11e3-80e9-20ae90200ddd"
        }]
      }


* `total_events` - Total number of matching events for the entire time range
* `page` - Which page of the result set
* `tags` - An Array of any tags associated with the event
* `timestamp` - See [timestamps](https://www.loggly.com/docs/timestamps/) to understand how a reference timestamps is derived.
* `logmsg` - The message portion of the log event. (Any headers aren't included.)
* `event` - Any parsed fields are included.
* `logtypes` - An array of [log types](https://www.loggly.com/docs/log-types/) that were detected.
* `id` - Loggly's event ID.

Try the following to get an array of all the event attributes:

    events = Loggly::Event.all
    events.collect {|event| event.attributes}

## TODO

1. Sending Data
2. Retrieve Account Information
3. Field Search
4. `OR`, `NOT` and `TO` search functionality
5. Filter Search by field
6. Command Line Tools


## Contributing

1. Fork it ( http://github.com/<my-github-username>/loggly/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
