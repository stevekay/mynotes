Create confluence page with embedded line graph chart

```
$ cat storage.html
<p class="auto-cursor-target"><br /></p><ac:structured-macro ac:name="chart" ac:schema-version="1" ac:macro-id="5fce5185-dd11-4f95-b957-d0e48951a76a"><ac:parameter ac:name="imageFormat">png</ac:parameter><ac:parameter ac:name="borderColor">green</ac:parameter><ac:parameter ac:name="bgColor">#eeeeee</ac:parameter><ac:parameter ac:name="subTitle">across servers</ac:parameter><ac:parameter ac:name="rangeAxisTickUnit">5</ac:parameter><ac:parameter ac:name="opacity">70</ac:parameter><ac:parameter ac:name="title">cpu stats</ac:parameter><ac:parameter ac:name="type">line</ac:parameter><ac:parameter ac:name="yLabel">CPU usage%</ac:parameter><ac:parameter ac:name="xLabel">Time</ac:parameter><ac:rich-text-body>
<p class="auto-cursor-target"><br /></p>
<table class="wrapped">
<thead>
<tr style="text-align: right;">
<th>#server</th>
<th>10:00</th>
<th>10:30</th>
<th>11:00</th></tr></thead>
<tbody>
<tr>
<td>web</td>
<td>25</td>
<td>27</td>
<td>30</td></tr>
<tr>
<td>app</td>
<td>5</td>
<td>15</td>
<td>19</td></tr>
<tr>
<td>db</td>
<td>35</td>
<td>32</td>
<td>37</td></tr></tbody></table>
<p class="auto-cursor-target"><br /></p></ac:rich-text-body></ac:structured-macro>
<p class="auto-cursor-target"><br /></p>
$ ./create-graph.py
$
```

![graph](./create-graph.png?raw=true "csv")
