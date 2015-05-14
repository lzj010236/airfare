import urllib
import urllib2
import json

def GetPriceJson(filename,origin,destination,time,key):
    def GetData(filename,origin,destination,time):
        f=open(filename)
        request_str=f.read().replace("ORG",origin).replace("DST",destination).replace("TIME",time)
        return request_str

    # url = 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyBdVobWYnDYRKuyUs2yVXnQM0bP97EjUTQ'
    url = 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=KEY'.replace("KEY",key)
    user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
    values = {'name' : 'Michael Foord',
              'location' : 'Northampton',
              'language' : 'Python' }

    headers = { "Content-Type" : "application/json" }

#    data = GetData(filename,"BOS","LAX","2015-07-11")
    data = GetData(filename,origin,destination,time)

# print data
    req = urllib2.Request(url, data, headers)
    response = urllib2.urlopen(req)
    the_page = response.read()
    # print the_page
    return the_page

def ProcessPriceJson(json_text):
    price_object=json.loads(json_text)['trips']['tripOption'][0:10]
    options=[]
    for option in price_object:
        # print json.dumps(option)
        # sale_price=option['pricing']['saleFareTotal']
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
            # print fr,to,depature,arrival
        options.append({"total":sale_total,"flights":flights})
        # print sale_total
        # break
    # print options
    json_str=json.dumps(options)
    # print json_str
    return json_str
    # return json.loads(str(options))
    # print json.dumps(price_object)

if __name__ == "__main__":
    google_json=GetPriceJson("request_template.json","BOS","LAX","2015-07-11","AIzaSyBdVobWYnDYRKuyUs2yVXnQM0bP97EjUTQ")
    json_string=ProcessPriceJson(google_json)
    print json_string
    # returned_object=ProcessPriceJson(open("test_response.json").read())
# json.dumps(returned_object)