{% for page in site.pages| sort:"path"%} [{% if page.url-title %} {{ page.url-title }} {% else %} {{ page.title }} {% endif %}]({{ page.url }}){% endfor %}
