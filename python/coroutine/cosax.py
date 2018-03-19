"""
An Event Stream

+------------+  events   +---------+  send  +----------------+
| SAX Parser | ========> | Handler | ======>| (event, value) |
+------------+           +---------+        +----------------+

event type
event value
"""

import xml.sax
import xml

class EventHandler(xml.sax.ContentHandler):
    def __init__(self, target):
        self.target = target

    def startElement(self, name, attrs):
        self.target.send(('start', (name, attrs._attrs)))

    def endElement(self, name):
        self.target.send(('end', name))

    def characters(self, text):
        self.target.send(('text', text))

xml.sax.parse("some.xml", EventHandler())
