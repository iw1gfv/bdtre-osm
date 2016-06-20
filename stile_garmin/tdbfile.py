#! /bin/python
# -*- coding: utf-8 -*-

import sys
import binascii

class block :
  pass

fn = sys.argv[1]
f = open ( fn , 'rb' )

# copyright messages are given as a list of tuples, the tuples contain
# the relevant header bytes as ints and the actual strings.

copyright = [ ( 0 , 3 , 'dati BDTRE: (c) La titolarità piena ed esclusiva del documento "BDTRE - Database GeoTopografico - 2016" è di Regione Piemonte (ai sensi della L. 633/41 e s.m.i)' ) ,
              ( 0 , 3 , "dati openstreetmap: (c) openstreetmap.org contributors, see http://wiki.openstreetmap.org/index.php/attribution" ) ,
              ( 15 , 3 , "Documento realizzato da Michele Marchello e Lucio Galosso, basato su BDTRE - Database GeoTopografico - 2016 e su dati openstreetmap" ) ]
              
content = ""

while True:
  
  b = block()
  
  b.b0 = f.read ( 1 )
  if not b.b0 : # file over
    break
  
  b.id = ord(b.b0)
  # print ( 'block ID: 0x%02x' % b.id )
  
  b.b1 = f.read ( 1 )
  b.b2 = f.read ( 1 )
  b.length = ord(b.b1) + 256 * ord(b.b2)

  # print ( 'block length: 0x%04x' % b.length )
  
  b.data = bytearray ( f.read ( b.length ) )

  if b.id == 0x54 : # crc block
    
    crc1 = b.data[0x02]
    crc2 = b.data[0x09]
    crc3 = b.data[0x0c]
    crc4 = b.data[0x11]
    
    b.crc = 256 * ( 256 * ( 256 * int(crc1) + int(crc2) ) + int(crc3) ) + int(crc4)
    
    # print ( 'crc in input file = 0x%08x' % b.crc )
    
    b.ccrc = binascii.crc32 ( content ) & 0xffffffff
    # print ( 'crc in output file = 0x%08x' % b.ccrc ) 
    
    # now patch the crc bytes with the calculated value:
    
    b.data[0x02] = ( b.ccrc >> 24 ) & 0xff
    b.data[0x09] = ( b.ccrc >> 16 ) & 0xff
    b.data[0x0c] = ( b.ccrc >> 8  ) & 0xff
    b.data[0x11] =   b.ccrc         & 0xff
    
  elif b.id == 0x44 : # copyright block

    pos = 0
    b.lines = []
    while pos < b.length :
      cb = block()
      cb.code = int ( b.data[pos] )
      cb.show = int ( b.data[pos+1] )
      cb.e1 =  int ( b.data[pos+2] )
      cb.e2 =  int ( b.data[pos+3] )
      cb.text = ""
      pos += 4
      while pos < b.length and b.data[pos] :
        cb.text += chr ( b.data[pos] )
        pos += 1
      cb.text += "\0"
    
      print ( 'found copyright text <%s>' % cb.text )
      b.lines.append ( cb )
      pos += 1

    cr_content = ""
    
    for cr in copyright :
      cr_content += chr ( cr[0] )
      cr_content += chr ( cr[1] )
      cr_content += chr ( cb.e1 )
      cr_content += chr ( cb.e2 )
      print ( 'writing copyright text <%s>' % cr[2] )
      cr_content += cr[2]
      cr_content += "\0"
    
    length = len ( cr_content )
    b.b1 = chr ( length & 0xff )
    b.b2 = chr ( ( length >> 8 ) & 0xff )
    b.data = cr_content
    
  # add the block to the string containing the output file data
  
  content += ( b.b0 + b.b1 + b.b2 + b.data )

f.close()

if len ( sys.argv ) > 2 :
  ofname = sys.argv[2]
else :
  ofname = sys.argv[1]

# write the output file
of = open ( ofname , 'wb' )
of.write ( content )
of.close()
  
