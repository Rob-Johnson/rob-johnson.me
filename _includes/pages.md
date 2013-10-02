{% for page in site.pages %}[{% if page.url-title %} {{ page.url-title }} {% else %} {{ page.title }} {% endif %}]({{ page.url }}){% endfor %}
