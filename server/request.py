import urllib
import urllib2
import json

def GetPriceJson(filename,origin,destination,time,key):
    def GetData(filename,origin,destination,time):
        f=open(filename)
        request_str=f.read().replace("ORG",origin).replace("DST",destination).replace("\"DATETIME\"","\""+time+"\"")
        return request_str

    # url = 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyBdVobWYnDYRKuyUs2yVXnQM0bP97EjUTQ'
    url = 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=KEY'.replace("KEY",key)
    user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
    values = {'name' : 'Michael Foord',
              'location' : 'Northampton',
              'language' : 'Python' }

    headers = { "Content-Type" : "application/json" }

    data = GetData(filename,origin.strip(),destination.strip(),time.strip())
    print data
    req = urllib2.Request(url, data, headers)
    response = urllib2.urlopen(req)
    the_page = response.read()
    return the_page

def ProcessPriceJson(json_text):
    trip_option_object=json.loads(json_text)['trips']['tripOption']
    length=min(30,len(trip_option_object))
    price_object=trip_option_object[0:length]
    options=[]
    counter=0
    for option in price_object:
        sale_total=option['saleTotal']
        segment_json=option['slice'][0]['segment']
        flights=[]
        for seg in segment_json:
            leg=seg['leg'][0]
            fr=leg['origin']
            to=leg['destination']
            depature=leg['departureTime']
            arrival=leg['arrivalTime']
            flight={"fr":fr,"to":to,"depature":depature,"arrival":arrival}
            flights.append(flight)
        options.append({"total":str(counter+1)+". "+sale_total,"flights":flights})
        counter+=1
    json_str=json.dumps(options)
    return json_str

if __name__ == "__main__":
    google_json=GetPriceJson("request_template.json","BOS","LAX","2015-07-11","AIzaSyBdVobWYnDYRKuyUs2yVXnQM0bP97EjUTQ")
    json_string=ProcessPriceJson(google_json)
    print json_string
    # returned_object=ProcessPriceJson(open("test_response.json").read())
# json.dumps(returned_object)