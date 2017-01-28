#!/usr/bin/python3
# -*- coding: utf-8 -*-

import urllib.request
import re
import time
import os
import json
import argparse

__version__ = 0.1

#############################################################
###         DEBUG                                         ###
#############################################################

_DEBUG = True

def setDebug(val=True):
    global _DEBUG
    _DEBUG = val

def d(args):
    if _DEBUG:
      print(args)


#############################################################
###          ARGUMENTS                                    ###
#############################################################

def parseArguments():

    parser = argparse.ArgumentParser(description='geocaching watcher.')
    parser.add_argument('-f', dest='dbfile', default='gcdata.json', help='database file')

    args = parser.parse_args()

    return args;

#############################################################
###           DOWNLOAD                                    ###
#############################################################

SEARCH_URL = 'http://www.geocaching.com/seek/nearest.aspx'


def buildParams(point):
  params = { }
  params['lat'] = point['lat']
  params['lng'] = point['lng']
  params['tx'] = point['tx']
  return params

def download(url, params = None):
  if (params):
    url_values = urllib.parse.urlencode(params)
    full_url = url + '?' + url_values
  else:
    full_url = url
  d(full_url)
  with urllib.request.urlopen(full_url) as response:
    return response.read()
   
########################################################
###         CONFIG                                   ###
########################################################

def loadTypes():
    with open('types.conf','r') as f:
      lines = f.readlines()

    return dict([line.split(maxsplit=1) for line in lines])

def loadPoints():

    with open('points.conf','r') as f:
      lines = f.readlines()

    types = loadTypes()

    result = []
    for l in lines:
       ll = l.split()
       if len(ll) < 3:
         d('Invalid line: ' + l)
         continue
       p = {}
       p['name'] = ll[0]
       p['lat'] = ll[1]
       p['lng'] = ll[2]
       for idx in range(3, len(ll)):
         if ll[idx] in types:
           p['tx'] = types[ll[idx]]
           p['type'] = ll[idx]
           result.append(p.copy())
         else:
           print('invalid type: %s' % ll[ix])
    return result

########################################################
###         PARSER                                   ###
########################################################

def parsePage(data, pointOfOrigin):
    result = {}
    p = re.compile('"http://www.geocaching.com/geocache/(GC[0-9A-Z]{4,6})_([^"]+)"')
    
    for m in p.finditer(data):
      matches = m.groups()
      result[matches[0]] = {
          'code':matches[0], 
          'urlName': matches[1], 
          'timestamp': int(time.time()),
          'type': pointOfOrigin['type'],
          'area': pointOfOrigin['name']
      }
      d(['found',m.start(),m.groups()])
    return result

def toStr(data):
  data = str(data, 'utf-8')
  return data


########################################################
###        DATABASE                                  ###
########################################################

def loadGcData(args):
    dbFile = args.dbfile
    
    if not os.path.exists(dbFile):
      return {}
    if os.path.isfile(dbFile):
      with open(dbFile, 'r') as f:
        jsonData = f.read()
    else:
      raise IOError("Invalid database file %s"%dbFile)
    
    result = json.loads(jsonData)
    return result
     
def storeGcData(gcData, args):
    jsonData = json.dumps(gcData, indent=4);

    dbFile = args.dbfile
    with open(dbFile, 'wt') as f:
        f.write(jsonData)

########################################################
###        MAIN                                      ###
########################################################

def addGccode(gcData, gcPoint):
    d(['add', gcPoint])
    gcCode = gcPoint['code']
    result = gcCode in gcData
    gcData[gcCode] = gcPoint
    return result

def main():

   args = parseArguments()
   gcData = loadGcData(args)

   points = loadPoints()
   
   for p in points: 
     params = buildParams(p)
     page = download(SEARCH_URL, params)
     pageStr = toStr(page)
     gcDict = parsePage(pageStr, p)

     for gcCode in gcDict:
       if not addGccode(gcData, gcDict[gcCode]):
         # new point
         d(['new', gcCode])


   storeGcData(gcData, args)

if  __name__ == '__main__':
    main()


