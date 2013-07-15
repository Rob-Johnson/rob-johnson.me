---
layout: post
title: About me
---
<h2>Archive</h2>
<ul id="archive">
{% for post in site.posts %}
  <li class="post-{{ post.category }}">
  {% if post.external_url == nil %}
    <a href="{{ post.url }}">{{ post.title }}</a><abbr>{{ post.date | date_to_string }}</abbr>
  {% else %}
    <a href="{{ post.external_url }}">{{ post.title }}</a><abbr>{{ post.date | date_to_string }}</abbr>
  {% endif %}
  </li>
{% endfor %}
</ul>