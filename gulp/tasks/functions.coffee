# functions
# --------------------
toUpper = (str) ->
	return str.toUpperCase()

urlEncode = (str) ->
	return encodeURIComponent(str)

n2br = (str) ->
	# 最後の不要な'\n'を削除
	newStr = str.slice(0, -1)
	return newStr.replace(/\n/g, '<br/>')

getPerformanceLength = ->
	len = 0
	for performer in data_artists.performers
		if performer.performance
			len = len+1
	return len

getMoreLength = ->
	len = 0
	for base in data_contents.bases
		for date in base.dates
			if date.more
				len = len+1
	return len


replace_text = (org, ptn, rep = '') ->
	if org is '' or ptn is ''
		return

	str = org.replace(ptn, rep)

	return str

split_text = (org, spl, odr) ->
	if org is '' or spl is ''
		return

	split = org.split(spl)
	str   = split[odr]

	return str

parse_int = (str) ->
	num = parseInt(str)
	return num

to_string = (int) ->
	val = int.toString()
	return val

excerpt_string = (str, limit, url='') ->
	if str.length > limit
		excerpt = str.substr(0, limit)

		if url isnt ''
			str = excerpt + '<a href="'+url+'">...続きを読む</a>'
		else
			str = excerpt

	return str






br2replace = (str) ->
	str.replace(/<br class="sp sp-lineup">/g, '')
	str.replace(/<br class="pc">/g, '')


replace_half_size = (str) ->
	createMap = (properties, values) ->
		if properties.length is values.length
			map = {}
			for i in [ 0...properties.length ]
				property = properties.charCodeAt(i)
				value = values.charCodeAt(i)
				map[property] = value
		return map

	m = createMap('アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンァィゥェォッャュョ','ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｯｬｭｮ')
	g = createMap('ガギグゲゴザジズゼゾダヂヅデドバビブベボヴ','ｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾊﾋﾌﾍﾎｳ')
	p = createMap('パピプペポ','ﾊﾋﾌﾍﾎ')
	e = createMap('ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')
	n = createMap('１２３４５６７８９０', '1234567890')
	k = createMap('！＠＃＄％＾＆＊（）＿＋｜〜ー＝￥：；’”＜＞？、。・　', '!@#$%^&*()_+|~-=¥:;\'\"<>?､｡･ ')
	gMark = 'ﾞ'.charCodeAt(0)
	pMark = 'ﾟ'.charCodeAt(0)

	half = (str) ->
		for i in [ 0...str.length+500 ]
			if g.hasOwnProperty(str.charCodeAt(i)) || p.hasOwnProperty(str.charCodeAt(i))
				if g[str.charCodeAt(i)]
					# 濁音文字
					str = str.replace(str[i], String.fromCharCode(g[str.charCodeAt(i)])+String.fromCharCode(gMark))
				else if p[str.charCodeAt(i)]
					# 半濁音文字
					str = str.replace(str[i], String.fromCharCode(p[str.charCodeAt(i)])+String.fromCharCode(pMark));
				else
					break
				i++
				_ref = str.length
			else
				if n[str.charCodeAt(i)]
				# 数字
					str = str.replace(str[i], String.fromCharCode(n[str.charCodeAt(i)]))
				else if e[str.charCodeAt(i)]
				# 英語
					str = str.replace(str[i], String.fromCharCode(e[str.charCodeAt(i)]))
				else if k[str.charCodeAt(i)]
				# 記号
					str = str.replace(str[i], String.fromCharCode(k[str.charCodeAt(i)]))
				else if m[str.charCodeAt(i)]
				# 通常カナ
					str = str.replace(str[i], String.fromCharCode(m[str.charCodeAt(i)]))
		return str
	half(str)