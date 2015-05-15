from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
from request import *
class IphoneChat(Protocol):
    def connectionMade(self):
        self.factory.clients.append(self)
        print "clients are ", self.factory.clients
 
    def connectionLost(self, reason):
        self.factory.clients.remove(self)
    def GenerateResults(self,a):
        print "request accepted",a
        arrs=a.replace("\n","").split(":")
        google_json=GetPriceJson("request_template.json",arrs[0],arrs[1],arrs[2],"AIzaSyBdVobWYnDYRKuyUs2yVXnQM0bP97EjUTQ")
        json_string=ProcessPriceJson(google_json)
        return json_string
    def dataReceived(self, data):
        send_msg=self.GenerateResults(data)
        print send_msg
        for c in self.factory.clients:
            c.message(send_msg)
    def message(self, message):
        self.transport.write(message + '\n')
factory = Factory()
factory.protocol = IphoneChat
factory.clients = []
reactor.listenTCP(5999, factory)
print "Airfare server started"
reactor.run()
