import XCTest
@testable import BlueSky

class WeatherDataTest: XCTestCase {

    func testCanParseWeatherResponse() throws {
        let json = """
         {
           "weather": [
             {
               "id": 804,
               "description": "overcast clouds",
             }
           ],
           "main": {
             "temp": 10.58,
           },
           "name": "Calgary"
         }
        """

        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)

        XCTAssertEqual(10.58, weatherData.main.temp)
        XCTAssertEqual("Calgary", weatherData.name)
    }
    
    func testCanParseWeatherWithoutCityName() throws {
        let json = """
         {
           "weather": [
             {
               "id": 804,
               "description": "overcast clouds",
             }
           ],
           "main": {
             "temp": 10.58,
           },
           "name": ""
         }
        """

        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)

        XCTAssertEqual(10.58, weatherData.main.temp)
        XCTAssertEqual("", weatherData.name)
    }
    
    func testCanParseWeatherJSONLocalFile() throws {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "OpenWeatherResponse", ofType: "json") else {
            fatalError("[Test Error] json not found")
        }

        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("[Test Error] Unable to convert json to String")
        }

        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)
        
        XCTAssertEqual(22.00, weatherData.main.temp)
        XCTAssertEqual("London", weatherData.name)
    }

}
