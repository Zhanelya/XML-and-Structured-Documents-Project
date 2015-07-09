# XML and Structured Documents Project
###HeapSort algorithm using XSL

The goal of this project is to use XSLT to implement the heapsort algorithm. You can find details of this algorithm in Thomas H. Cormen, Charles E. Leiserson, and Ronald H. Rivest, Introduction
to Algorithms (MIT 1994), Chapter 6. 

#####Components:

• An XML Schema which defines the heap data structure.

• An XSLT stylesheet which includes the named functions Heapify, Build-Heap, and Heapsort which implement the algorithms with those names defined in Cormen et al.. The stylesheet should
be applied to documents with the following schema:

<?xml version="1.0" encoding="UTF-8" ?>

<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xs:element name="listOfNumbers" type="numList"/>

<xs:simpleType name="numList">

<xs:list itemType="xs:integer"/>

</xs:simpleType>

</xs:schema>


This represents a list of integers. It should output documents with the same schema, but sorted,
using the heapsort algorithm.

• Test data that used to verify that the algorithm functions correctly.

Please check the pdf report for a complete guide
