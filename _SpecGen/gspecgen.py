#!/usr/bin/python
# -*- coding: utf8 -*-

# A GTK front-end for SpecGen
# (compatible with SpecGen v5)

# This software is licensed under the terms of the MIT License.
# 
# Copyright (c) 2008 Sergio Fernández <sergio.fernandez@fundacionctic.org>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import os
import sys
import gtk
import gtk.glade
import pygtk
pygtk.require("2.0")
from subprocess import Popen, PIPE
import string
import webbrowser

#flags
dev = False

class Callbacks:

    def exit(self):
        global widgets
        window = widgets.get_widget("gspecgenwin")
        window.destroy()
        gtk.main_quit()

    def showAboutDialog(self):
        global widgets
        about = widgets.get_widget("gSpecGen")
        about.show()

    def closeAboutDialog(self, foo):
        self.hide()
        return gtk.TRUE

    def generateButtonClicked(self):
        global widgets
        path = widgets.get_widget("path-entry").get_text()
        ontology = widgets.get_widget("ontology-entry").get_text()
        prefix = widgets.get_widget("prefix-entry").get_text()
        template = widgets.get_widget("template-entry").get_text()
        destination = widgets.get_widget("destination-entry").get_text()
        instances = widgets.get_widget("instances-check").get_active()
        if (len(path)>0 and os.path.exists(path) and os.path.isfile(path) and
            len(ontology)>0 and os.path.exists(ontology) and os.path.isfile(ontology) and
            len(template)>0 and os.path.exists(template) and os.path.isfile(template) and
            len(prefix)>0 and len(destination)>0):
            statusbar = widgets.get_widget("statusbar1")
            statusbar.push(0, "Generating specification...")
            executeSpecGen(path, ontology, prefix, template, destination, instances)
            statusbar.push(0, "Specification generated!")
        else:
            widgets.get_widget("statusbar1").push(0, "Error: Incomplete Input Data")

    def viewButtonClicked(self):
        specification = widgets.get_widget("destination-entry").get_text()
        if (len(specification)>0 and os.path.exists(specification)):
            webbrowser.open(specification)
        else:
            print "Specfication doesn't exist"

    def setFileChooser(self):
        global widgets
        name = self.get_name().split("-")[0]
        entry = widgets.get_widget(name + "-entry")
        path = self.get_filename()
        if (path == None):
            path = ""
        entry.set_text(path)

    def entryChanged(self):
        global widgets
        name = self.get_name().split("-")[0]
        path = self.get_text()
        button = widgets.get_widget(name + "-filechooserbutton")
        if (os.path.exists(path) and os.path.isfile(path)):
            button.set_filename(path)
        else:
            button.set_filename("")
            #FIXME: drop icon


        if (name == "destination"):
            viewButton = widgets.get_widget("viewButton")
            if (os.path.exists(path) and os.path.isfile(path)):
                viewButton.set_sensitive(True)
            else:
                viewButton.set_sensitive(False)            

            
def putCommonData():
    global widgets
    widgets.get_widget("ontology-entry").set_text("/home/sergio/projects/MyMobileWeb/morfeo/MyMobileWebOntologies/W3C/final/deliveryContext03012008.owl")
    widgets.get_widget("prefix-entry").set_text("dc")
    widgets.get_widget("template-entry").set_text("/home/sergio/projects/MyMobileWeb/morfeo/SpecGen/template.html")
    widgets.get_widget("destination-entry").set_text("/home/sergio/projects/MyMobileWeb/morfeo/MyMobileWebOntologies/W3C/final/deliveryContext03012008.html")
    widgets.get_widget("instances-check").set_active(True)


def prepareForm():
    global widgets
    pathEntry = widgets.get_widget("path-entry")
    pathButton = widgets.get_widget("path-filechooserbutton")
    pathButton.set_filename(pathEntry.get_text())


def executeSpecGen(path, ontology, prefix, template, destination, instances=False):
    if dev:
        python = "python2.5"
    else:
        python = "python"
    command = "%s %s %s %s %s %s" % (python, path, ontology, prefix, template, destination)
    if instances:
        command += " -i"
    #print command
    p = Popen(command, shell=True,stdout=PIPE,stderr=PIPE)
    out = string.join(p.stdout.readlines())
    outerr = string.join(p.stderr.readlines())


if __name__ == "__main__":
    global widgets
    try:
        widgets = gtk.glade.XML("./gspecgen.glade")
        callbacks = Callbacks()
        widgets.signal_autoconnect(Callbacks.__dict__)
        prepareForm()
        window = widgets.get_widget("gspecgenwin")
        widgets.get_widget("statusbar1").push(0, "Ready")
        if dev:
            putCommonData()
        window.show()
        gtk.main()
    except KeyboardInterrupt:
        sys.exit("Received Ctrl+C or another break signal. Exiting...")

