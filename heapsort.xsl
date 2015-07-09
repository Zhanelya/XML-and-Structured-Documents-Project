<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="my:my"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <!-- Group1: Soham Amrish Trivedi, Zhanelya Subebayeva -->
    <!-- run xsl transformation from xml file, not from xsl - Run only on UNIX system, and ideally on Oxygen v15.0 (not tested on 16) -->
    
    <!-- 
    Order of Functions;
    Exchange ln 35
    Heapify ln 76
    Build-Max-Heap-Iterator ln 144
    Build-Max-Heap ln 175
    Heapsort-Iterator ln 194
    Heapsort ln 242
    -->
    
    <xsl:template match="/">
        <!-- create an array of numbers from XML input list - "data()" Takes a sequence of items and returns a sequence of atomic values -->
        Input <!-- output initial list of numbers UNDO POINT! -->
        <xsl:variable name="vArray" select="data(listOfNumbers)"/>
        <xsl:value-of select="$vArray"/>
        <!-- For parameters and variables that are referenced often
                a prefix of p or v has been added to the name
                for easy readability.
            -->
        Build-Max-Heap <!-- output buildheap result-->
        <xsl:call-template name="Build-Max-Heap">
            <xsl:with-param name="pLength" select="count($vArray)"/>
            <xsl:with-param name="pArray" select="$vArray"/>
        </xsl:call-template> 
        Heapsort <!-- output heapsort result-->
        <xsl:call-template name="Heapsort">
            <xsl:with-param name="pArray" select="$vArray"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="exchange">
        
        <xsl:param name="i"/>
        <!-- index of the selected node -->
        <xsl:param name="pArray"/>
        <xsl:param name="k"/>
        <!-- initially = 1 -->
        <xsl:param name="largest"/>
        <!-- index of the child node with larger value -->
        
        <xsl:variable name="vLength" select="count($pArray)"/>
        <xsl:if test="($k &lt;= $vLength)">
            <!-- whilst k is less than array length -->
            <xsl:choose>
                <xsl:when test="$k=$i">
                    <!-- switching the the values of the node and its child -->
                    <xsl:value-of select="concat($pArray[position()=$largest],' ')"/>
                </xsl:when>
                <xsl:when test="$k=$largest">
                    <!-- switching the the values of the node and its child -->
                    <xsl:value-of select="concat($pArray[position()=$i],' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- store the value of the current node if k is not pointing at the child/parent values that need to be switched -->
                    <xsl:value-of select="concat($pArray[position()=$k],' ')"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:call-template name="exchange">
                <xsl:with-param name="i" select="$i"/>
                <xsl:with-param name="pArray" select="$pArray"/>
                <xsl:with-param name="k" select="$k +1"/>
                <!-- move through the array by incrementing k -->
                <xsl:with-param name="largest" select="$largest"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>
    <!-- end exchange -->
    
    <xsl:template name="Heapify">
        
        <xsl:param name="i"/>
        <xsl:param name="pLength"/>
        <xsl:param name="pArray"/>
        
        <!-- store index of left and right children -->
        <xsl:variable name="l" select="(2 * $i) "/>
        <xsl:variable name="r" select="(2 *$i) + 1"/>
        
        <!-- store values of left and right children and the node itself -->
        <xsl:variable name="node" select="number($pArray[position() = $i])"/>
        <xsl:variable name="lValue" select="number($pArray[position() = $l])"/>
        <xsl:variable name="rValue" select="number($pArray[position() = $r])"/>
        
        <!--determine which node has the greatest value -->
        <xsl:variable name="largest">
            <xsl:choose>
                <xsl:when test="(($l &lt;= $pLength) and ($lValue &gt; $node))">
                    <xsl:value-of select="$l"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$i"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="largest">
            <xsl:choose>
                <xsl:when
                    test="(($r &lt;= $pLength) and ($rValue &gt; number($pArray[position() = $largest])))">
                    <xsl:value-of select="$r"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$largest"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$largest != $i">
                <!-- if the node is smaller than its children (if the exchange is needed) -->
                <xsl:variable name="tmp_array">
                    <xsl:call-template name="exchange">
                        <!-- exchange node with the largest of its children (exchange A[i] with A[largest]) -->
                        <xsl:with-param name="i" select="$i"/>
                        <xsl:with-param name="pArray" select="$pArray"/>
                        <xsl:with-param name="k" select="1"/>
                        <xsl:with-param name="largest" select="$largest"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="vArray" select="tokenize($tmp_array,' ')"/>
                <!-- remove spaces from returned array string -->
                <xsl:call-template name="Heapify">
                    <xsl:with-param name="i" select="$largest"/>
                    <xsl:with-param name="pLength" select="$pLength"/>
                    <xsl:with-param name="pArray" select="$vArray"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pArray"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <!-- end Heapify -->
    
    <xsl:template name="Build-Max-Heap-Iterator">
        <!-- iterates from length/2 down to 1-->
        
        <xsl:param name="i"/>
        <xsl:param name="pLength"/>
        <xsl:param name="pArray"/>
        
        <xsl:if test="$i eq 0">
            <!-- exit loop -->
            <xsl:value-of select="$pArray"/>
        </xsl:if>
        <xsl:if test="$i &gt;= 1">
            <xsl:variable name="vArray">
                <xsl:call-template name="Heapify">
                    <!-- push element[i] down untill it's in the right place-->
                    <xsl:with-param name="i" select="$i"/>
                    <xsl:with-param name="pLength" select="$pLength"/>
                    <xsl:with-param name="pArray" select="$pArray"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="vArray" select="tokenize($vArray,' ')"/>
            <xsl:call-template name="Build-Max-Heap-Iterator">
                <xsl:with-param name="i" select="$i - 1"/>
                <xsl:with-param name="pLength" select="$pLength"/>
                <xsl:with-param name="pArray" select="$vArray"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>
    <!-- end Build-Mac-Heap-Iterator -->
    
    <xsl:template name="Build-Max-Heap">
        
        <xsl:param name="pLength"/>
        <xsl:param name="pArray"/>
        <xsl:variable name="i" select="round($pLength div 2)"/>
        <!-- start on the middle element, round to make it work on odd length lists -->
        <xsl:variable name="vArray">
            <xsl:call-template name="Build-Max-Heap-Iterator">
                <xsl:with-param name="i" select="$i"/>
                <xsl:with-param name="pArray" select="$pArray"/>
                <xsl:with-param name="pLength" select="$pLength"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$vArray"/>
        
    </xsl:template>
    <!-- end Build-Max-Heap -->
    
    <xsl:template name="Heapsort-Iterator">
        <!-- iterates from length down to 2-->
        
        <xsl:param name="i"/>
        <xsl:param name="pLength"/>
        <xsl:param name="pArray"/>
        
        <xsl:choose>
            <xsl:when test="$i = 1">
                <!-- exit loop -->
                <xsl:value-of select="$pArray"/>
            </xsl:when>
            <xsl:otherwise>
                
                <xsl:variable name="array1">
                    <xsl:call-template name="exchange">
                        <!-- swap the first and last element (the largest gets to the bottom) (exchange A[i] with A[1]) -->
                        <xsl:with-param name="i" select="1"/>
                        <xsl:with-param name="pArray" select="$pArray"/>
                        <xsl:with-param name="k" select="1"/>
                        <xsl:with-param name="largest" select="$i"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="vArray" select="tokenize($array1,' ')"/>
                <xsl:variable name="array2">
                    <xsl:call-template name="Heapify">
                        <!-- call Heapify on (array, new root) -->
                        <xsl:with-param name="i" select="1"/>
                        <xsl:with-param name="pLength" select="$pLength - 1"/>
                        <!-- exclude the last element from the next call, as it is already in the right place -->
                        <xsl:with-param name="pArray" select="$vArray"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="vArray" select="tokenize($array2,' ')"/>
                <xsl:call-template name="Heapsort-Iterator">
                    <xsl:with-param name="i" select="$i - 1"/>
                    <xsl:with-param name="pLength" select="$pLength - 1"/>
                    <xsl:with-param name="pArray" select="$vArray"/>
                </xsl:call-template>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <!-- end Heapsort-Iterator -->
    
    <xsl:template name="Heapsort">
        
        <xsl:param name="pArray"/>
        
        <xsl:variable name="vLength" select="count($pArray)"/>
        <xsl:variable name="vArray">
            <!-- assign result/return value of a call-template to a variable-->
            <xsl:call-template name="Build-Max-Heap">
                <xsl:with-param name="pLength" select="$vLength"/>
                <xsl:with-param name="pArray" select="$pArray"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="vArray" select="tokenize($vArray,' ')"/>
        <!-- remove spaces from returned array string -->
        <xsl:call-template name="Heapsort-Iterator">
            <xsl:with-param name="i" select="$vLength"/>
            <!-- set to last element of a list -->
            <xsl:with-param name="pLength" select="$vLength"/>
            <xsl:with-param name="pArray" select="$vArray"/>
        </xsl:call-template>
        <!-- end Heapsort -->
        
        
    </xsl:template>
    
</xsl:stylesheet>
