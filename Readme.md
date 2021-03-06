# Blue Sky
## iOS Weather Application

### Blue Sky is a weather application built using best practices with Swift 5, UIKit and XCode 12.  Blue Sky demonstrates scalable, reusable code that is easily reviewed by peers. 


## What's Inside?

- No storyboards! 
- Dynamic retina enabled background images
- Stack Views
- Protocol-Delegate Pattern
- JSON Parsing with `Codable`
- HTTP URLSession
- Swift Unit Testing _TDD!!_
- Styling text with NSAttributedString _easy and efficent!_ 
- Automatic retrieval of user location via `CoreLocation`
- Allow users to manually search for a weather report using `UITextFieldDelegate`
- Error Handling

## Benefits of the techniques used here

- Auto layout uses mathematical equations to place UI elements on screen, in the background it is 
simple linear algebra that brings views to life. This is how the application can be rendered on 
multipe screen sizes with programatically defined layouts. The anchoring system 
(top/leading/trailing/bottom) in autolayout is key here. 
- The protocol-delegate pattern is common with `UIKit` because it sovles a probelm with communication.  Classes use protocols
to broadcast events.  Delegates receive communications from the protocol. In doing so, this reduces coupling between classes. It 
does a really good job of separating responsibility between generating an event and reacting to it. 
- Since storyboards show up as a .xml file during the code review process, programatic layouts are much 
easier to collaborate on. 
- Stack views are Apple's way of streamlining a layout for a collection of views (for a column or row). 
This allows us to define fewer constraints and get the same results. UIStackView works perfectly for 
certain elements of BlueSky. Not to mention, this leads to fewer lines of code and therefore a more
efficient development workflow.
- Although minimally used here, because the scope of this app is limited, `NSAttributedString` is a welcome
addition to BlueSky.  The city, state and temperature labels on screen are a key part of the UI. This technique
allows us to apply different styles to each part of the string (for example 10ºC). 


## The Protocol-Delegate relationship in this app

- We define a `WeatherService` with a function called `fetchWeather()` which communicates via a delegate.
In order to accomplish this, we define a protocol called `didFetchWeather` (implemented in `WeatherViewController`).
Second, we have to register a callback (delegate) for the protocol. This way, when `fetchWeather()` is called, 
it has an instance (reference) via the delegate.  It can pass the weather object and therefore update the UI.

## A note on (the wonderful) Codable
### Decoding
- Codable is the bridge between JSON and swift.  Say we have JSON coming in from an API representing Weather data. We can convert this JSON into a `struct` by 
defining a `struct` that matches the incoming JSON.  Then, all we need to do is use the `JSONDecoder` to decode the json, which matches the `Weather` type. The 
JSON is **decoded** into a swift construct that we can access within our codebase. This is typically used to GET data from an API. 

### Encoding
- We can go from Swift to JSON by using the `JSONEncoder`. This process is essentially decoding in reverse, as we can go from a `struct` to `JSON`. This is used to send data TO an API using POST or PUT for example. 

### Coding Keys
- For a developer like myself, who only uses camelCase in Swift files, sometimes JSON data with `snake_case` presents a threat to my coding style.  `CodingKeys` bridge how we would like to represent data in Swift, with how it is coming in from JSON. `CodingKeys` are nothing more than a creative use for `enum`. 

## The Importance Testing (Swift Unit Tests)
- Lots of things can go wrong in an application like this, for example JSON parsing exceptions.  Unit tests can help reassure the product owner that the software is stable, even after major feature additions.  Everyone likes avoiding bugs in prod! 

### What is a Unit Test? 
- Unit tests are small method-level tests that developers write to prove to themselves that the code is working as expected. 

#### Advantages of Unit Testing
1. **Instant feedback** - when a developer makes changes to the code, a failing (or passing) test allows us to know instantly if changes have broken some piece of the codebase. 
1. **Lower the cost of regression testing** - Instead of testing the entire app, we can focus on testing new features and leave the rest to automation. Of course, this depends on well written tests covering a large portion of the codebase.
1. **Decrease debugging time** - When a unit test fails, we know exactly where to look for a problem. No more firing up the debugger and stepping through thousands of lines of code.
1. **Deploy with confidence** - Let's be honest, it just feels good to see a suite of well written unit tests passing before deployment. Humans can focus on testing the more complex features and user experience. 
