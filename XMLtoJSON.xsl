<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<!-- Object or Element Property-->
	<xsl:template match="//JsonPayload//*">
    "<xsl:value-of select="name()"/>" :<xsl:call-template name="Properties">
			<xsl:with-param name="parent" select="'Yes'"> </xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Array Element -->
	<xsl:template match="//JsonPayload//*" mode="ArrayElement">
		<xsl:call-template name="Properties"/>
	</xsl:template>
	<xsl:template match="//JsonPayload1//*">
    "<xsl:value-of select="name()"/>" :<xsl:call-template name="Properties">
			<xsl:with-param name="parent" select="'Yes'"> </xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Array Element -->
	<xsl:template match="//JsonPayload1//*" mode="ArrayElement">
		<xsl:call-template name="Properties"/>
	</xsl:template>
	<!-- Object Properties -->
	<xsl:template name="Properties">
		<xsl:param name="parent"/>
		<xsl:variable name="parentName" select="name()"/>
		<xsl:variable name="childName" select="name(*[1])"/>
		<xsl:choose>
			<xsl:when test="not(*|@*)">
				<xsl:choose>
				
					<xsl:when test="$parent='Yes'">
						<xsl:text>&quot;</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>&quot;</xsl:text>
					</xsl:when>
					<xsl:otherwise>"<xsl:value-of select="name()"/>":"<xsl:value-of select="."/>"</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- attachments group is always an array for the notification service api -->
			<xsl:when test="count(*[name()=$childName]) > 1  and $parentName != 'attachments'">{ "<xsl:value-of select="$childName"/>" :[<xsl:apply-templates select="*" mode="ArrayElement"/>] }</xsl:when>
			<xsl:when test="$parentName = 'attachments'">[ <xsl:apply-templates select="./*" mode="ArrayElement"/>]</xsl:when>
			<xsl:when test="$parentName = 'bcc'">[ <xsl:apply-templates select="./*" mode="ArrayElement"/>]</xsl:when>
			<xsl:when test="$parentName = 'cc'">[ <xsl:apply-templates select="./*" mode="ArrayElement"/>]</xsl:when>
			<xsl:otherwise>{
            <xsl:apply-templates select="@*"/>
				<xsl:apply-templates select="*"/>
            }</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="following-sibling::*">,</xsl:if>
	</xsl:template>
	<!-- Attribute Property -->
	<xsl:template match="@*">"<xsl:value-of select="name()"/>" : "<xsl:value-of select="."/>",
</xsl:template>
</xsl:stylesheet>