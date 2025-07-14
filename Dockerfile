FROM httpd:2.4

RUN sed -i '/#LoadModule cgi_module/s/^#//' /usr/local/apache2/conf/httpd.conf \
    && echo "ScriptAlias /cgi-bin/ \"/usr/local/apache2/cgi-bin/\"" >> /usr/local/apache2/conf/httpd.conf \
    && echo "<Directory \"/usr/local/apache2/cgi-bin\">" >> /usr/local/apache2/conf/httpd.conf \
    && echo "    Options +ExecCGI" >> /usr/local/apache2/conf/httpd.conf \
    && echo "    AddHandler cgi-script .sh" >> /usr/local/apache2/conf/httpd.conf \
    && echo "</Directory>" >> /usr/local/apache2/conf/httpd.conf

COPY html/*.html /usr/local/apache2/htdocs/
COPY html/cgi-bin/*.sh /usr/local/apache2/cgi-bin/

RUN chmod +x /usr/local/apache2/cgi-bin/*.sh

EXPOSE 80

CMD ["httpd-foreground"]