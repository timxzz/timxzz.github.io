---
layout: page
permalink: /publications/
title: Publications
description: My areas of interest in machine learning include Bayesian deep learning, deep probabilitic models and their applications.
years: [2025, 2024, 2023, 2022, 2021, 2020, 2016]
nav: true
nav_order: 1
---
<!-- _pages/publications.md -->
<div class="publications">

{%- for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
