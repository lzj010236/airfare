from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
 
class IphoneChat(Protocol):
    def connectionMade(self):
        self.factory.clients.append(self)
        print "clients are ", self.factory.clients
 
    def connectionLost(self, reason):
        self.factory.clients.remove(self)
    def GenerateResults(self,a):
        arrs=a.replace("\n","").split(":")
        line=arrs[0]+" "+arrs[1]+" "+arrs[2]
        # print line
        st=line+"\t"+line+"\t"+line
        # st=st+"+"+line
        # print st
        return st
    def dataReceived(self, data):
        # a = data.split(':')
        print data
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
print "Iphone Chat server started"
reactor.run()
