#Vertetungsplan Parser
This is a parser for the substitute plan of my school. It should work with every other school's substitute plan as long as it's created with [Untis](http://www.grupet.at/) (As required by Berlin senate). You need to edit the urls in `config/urls.yml` to match your school's setup. The parser itself should be pretty forgiving when it comes to errors but you may need to adapt your implementation depeding on how your secretary is using the system.

#Changes
 - **Sept. 19**: Removed was/room because it's not included by the server anymore

#Running the Server
The server should run automatically on heroku. If you want to test locally run `ruby web.rb` then navigate to *http://localhost:4567/monday.json*.

#Responses

```json
{
   meta: {
      valid_on: "2013-09-18 00:00:00 +0200",
      week: "A",
      modified: "2013-09-16 16:46:40 +0200",
      info: "12. Jahrgang (Q3) 1. Block Sport Die Schüler des Schwimmkurses und des Tenniskurses finden sich um 07:15 Uhr auf dem Sportplatz AdK ein. Bundesjugendspiele 2013 (Ablauf siehe Terminplan ONG)",
      fetched: "2013-09-16 20:36:50 +0200"
   },
   substitutes: {
      5: [
         {
            period: 1,
            type: "Reserve vor Ort",
            text: "Sondereins.",
            was: {
               teacher: "Wend",
               shorthand: "Ma",
               room: "018"
            },
            is: {
               teacher: "Arnd",
               shorthand: "",
               room: "Sportplatz AdK"
        },
         {
            period: 3,
            type: "Vertretung",
            text: "",
            was: {
               teacher: "Gold",
               shorthand: "Inf",
               room: "017"
            },
            is: {
               teacher: "Dorn",
               shorthand: "Inf",
               room: "017"
        },
      ]
    }
}

```

A response is a JSON file (or Javascript-Object when using JSONP) that has a meta and a susbtitutes element.

##Error messages
On errors a json document with the appropriate error code and an error message is returend.

```json

{
   success: false,
   general_message: "No day 'unicorn' was found.",
   errors: {
      day: "Must be 'monday', 'tuesday', 'wednesday', 'thursday, or 'friday'."
   }
}

```

#Requests
You can request the following days: *monday*, *tuesday*, *wednesday*, *thursday* nad *friday* (Or as specified in the *urls.yml*-file).
A request is made by calling the server with a the requested date and the *.json* file extension. (Eg. `http://example.com/monday.json`).

##JSONP
You can optionally pass a `?callback=`-element to support cross-origin-requests. This should happen automatically when requesting the servers with libraries like jQuery or Zepto.

##Only modified
If your are only interested in the modification date of the substitute plan (To prevent loading of old plans or to trigger push notifications) you can make a modified request by callig `/[day].json/modified`. The server will send back a document with the same *date* property as the origin.

##Filters
You can filter responses for specific classes by passing a `?filter=`-argument with comma separated values (eg `?filter=1.%20Semester, 6.1`).
