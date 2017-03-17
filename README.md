[![mm_header.jpg](https://s16.postimg.org/674mqlohx/mm_header.jpg)](https://postimg.org/image/dzvaikugx/)

# ios-currencyselection
show case of how to get the list of countries with their respective currencies and flags

## Installation

Download the repository en copy the following files:

* Country.swift
* CountryTableViewCell.xib
* CountryTableViewCell.swift
* BaseCountryTableViewController.swift
* ResultsCountryTableController.swift
* MainCountryTableViewController.swift
* CustomExtentions.swift

[![Mar-16-2017 17-02-50.gif](https://s25.postimg.org/efz1cttdr/Mar_16_2017_17_02_50.gif)](https://postimg.org/image/blvvzdr7f/)

## Use

On your main storyboard create a `TableViewController` and in the Identity Inspector set the Custom class to `MainCountryTableViewController`, then select the TableView and in the Attributes Inspector set the Prototypes Cells to `0` and set the Separator to `None`

Before you show the table, you must set all the list of the countries, you can see in the `HomeViewController.swift` of the Demo Project, in the `prepareForSegue` function the following code to set the countries

```swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destination is MainCountryTableViewController {
            let countries: [Country] = Country.getCountries()
            
            let destination:MainCountryTableViewController = segue.destination as! MainCountryTableViewController
            destination.countries = countries
        }
    }
```

In the `Country` class the `getCountries()` function gets all the countries based on their ISO country Code eg. 'US' with the following information localizaded on the current Locale from the device

* Country Name (United States)
* Country Code (US)
* Currency Code (USD)
* Currency Name (US Dollar)
* Currency Symbol (US$)
* Emoji Symbol (🇺🇸)
 
When you select a country from the list it will post a notification, specifically `updateCurrency` notification so you must subscribe to this notification, and to get the current ISO Country Code, it will be storage at `countryCode` key in the user preferences, since only the ISO code will be storage you can get all the details by calling the static function `getCountry(code: String)` from the `Country` class.

## Example



## License

This project is is available under the MIT license. See the LICENSE file for more info. Attribution by linking to the [project page](https://github.com/RomeRock/ios-currencyselection) is appreciated.

## Follow us!

<div>
<a href="http://romerock.com"> <img style="max-width: 100%; margin:7" src="https://avatars3.githubusercontent.com/u/23345883?v=3&s=200=true" alt="Google Play" height="50px" /> </a><a href="https://www.facebook.com/romerockapps/?ref=page_internal"> <img style="max-width: 100%; margin:7" src="https://s18.postimg.org/6sjokzpd5/facebook_icon.png=true" alt="Google Play" height="50px" /> </a><a href="https://twitter.com/romerock_apps"> <img style="max-width: 100%; margin:7" src="https://s18.postimg.org/w2eg82w4p/twitter_icon.png=true" alt="Google Play" height="50px" /> </a><a href="https://play.google.com/store/apps/dev?id=5841338539930209563"> <img style="max-width: 100%; margin:7" src="https://s18.postimg.org/n29unw015/android_icon.png=true" alt="Google Play" height="50px" /> </a><a href="https://itunes.apple.com/us/developer/rome-rock-llc/id1190244007"> <img style="max-width: 100%; margin:7" src="https://s18.postimg.org/leap98m5l/ios_icon.png=true" alt="Google Play" height="50px" /> </a><a href="https://github.com/RomeRock"> <img style="max-width: 100%; margin:7" src="https://s18.postimg.org/wpdcxlt0p/github_icon.png=true" alt="Google Play" height="50px" /> </a><a href="https://www.youtube.com/channel/UCcSLNuTYC7qJhOKQ4CpseRA"> <img style="max-width: 100%; margin:7" src="https://s18.postimg.org/w4ybuwzs9/youtube_icon.png=true" alt="Google Play" height="50px" /> </a>
</div>