import xml.sax

class MyHandler(xml.sax.ContentHandler):
    def startElement(self, name, attrs):
        print("startElement", name)

    def endElement(self, name):
        print("endElement", name)

    def characters(self, text):
        pritn("characters" repr(text)[:40])

xml.sax.parse("somefile.xml", MyHandler())
