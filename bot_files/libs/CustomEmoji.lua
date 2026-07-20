local M = {}

-- جدول الإيموجيات العادية → custom_emoji_id (كـ integer لـ TDLib)
M.map = {
  -- فلوس / بنك
  ['💰'] = 5915939776585797833,
  ['💵'] = 6174904941367269133,
  ['🔠'] = 5008536912063890739,
  ['💳'] = 5269472852653912623,
  ['💎'] = 5294460341021862670,
  ['🪙'] = 5271655928695892247,
  ['💐'] = 6007999677566294575,
  ['🎉'] = 5193209274452425995,
  -- وجوه
  ['😀'] = 5985641396378275403,
  ['😁'] = 5359768020291957179,
  ['😂'] = 5812067083453734412,
  ['😇'] = 5370947515220761242,
  ['😏'] = 5384214488809490070,
  ['😉'] = 5985599838274720348,
  ['😋'] = 5371057462088570593,
  ['😌'] = 6253704461533844884,
  ['😍'] = 5458407785400120492,
  ['😎'] = 5193101706996498352,
  ['💞'] = 5807448013630606457,
  ['😐'] = 5447348871678154623,
  ['😒'] = 5384059066827949054,
  ['😓'] = 5415838040952157397,
  ['😔'] = 5323316671505517569,
  ['😕'] = 5427140170082172715,
  ['😣'] = 5195177546295031423,
  ['😘'] = 5935953155954053636,
  ['😙'] = 5854857829738878987,
  ['😛'] = 5980823800281831278,
  ['😜'] = 5427255159241590813,
  ['😝'] = 5192908016856349010,
  ['😞'] = 5915521494015807999,
  ['😟'] = 5335024808189007974,
  ['😠'] = 5814370062097717288,
  ['😡'] = 5303064564970042656,
  ['😢'] = 5193134688050363591,
  ['😤'] = 5370650883304462905,
  ['😭'] = 5918100608992154817,
  ['😧'] = 5192840366826472325,
  ['😨'] = 5352549060735674292,
  ['🙏'] = 5217614738917173774,
  ['😪'] = 5821431976174819987,
  ['😫'] = 5210808229365305258,
  ['😬'] = 5190958793193710110,
  ['😮'] = 6255518316417259214,
  ['😯'] = 5399988606607564193,
  ['😱'] = 5370810157871667232,
  ['🤗'] = 5875320978082371182,
  ['🫦'] = 5447630192036040634,
  ['😴'] = 6298513503145691368,
  ['😵'] = 5372869745013954798,
  ['😷'] = 5276341939879296790,
  ['🙂'] = 5841323640464873985,
  ['🙃'] = 5373179691328871991,
  ['🙄'] = 5936274488227271514,
  ['🥰'] = 5917783069175060578,
  ['🥱'] = 5875381704624969270,
  ['🥳'] = 6253465326344738882,
  ['🥴'] = 5370571834431380930,
  ['🥵'] = 5199809853207371944,
  ['🥶'] = 5258397811329739167,
  ['🥺'] = 5915539721857012722,
  ['👌'] = 5363874941034843883,
  ['🤑'] = 6174447308306914013,
  ['🤒'] = 5201818995958765775,
  ['🤓'] = 5463211710615663536,
  ['🤔'] = 5192931484557654702,
  ['🤕'] = 5386807296141577893,
  ['🤠'] = 5384268407828924341,
  ['🤡'] = 5269531045165816230,
  ['🤢'] = 5262484296618227014,
  ['🤣'] = 6253704508778485322,
  ['🤤'] = 5192833387504613372,
  ['🤥'] = 5233698085770640533,
  ['🤧'] = 5442802077564675574,
  ['🤩'] = 5916008534717240329,
  ['🤪'] = 5875273179391333398,
  ['🤫'] = 5341369986713660416,
  ['🤭'] = 5875494713804461207,
  ['🤮'] = 5377344615605083432,
  ['🤯'] = 5456458329809232528,
  ['🧐'] = 5447610314927396099,
  -- علم سوريا
  ['🇸🇾'] = 5008273978460996904,
  -- ألعاب / رياضة
  ['📃'] = 5839415360725456219,
  ['✂️'] = 5237808360882977239,
  ['🕹️'] = 5017157809075127025,
  ['🎲'] = 5280816565657300091,
  ['🎯'] = 5256131095094652290,
  ['🎰'] = 6174733061071051782,
  ['🏆'] = 5294442254914578054,
  ['🥇'] = 5440539497383087970,
  ['🥈'] = 5447203607294265305,
  ['🥉'] = 5453902265922376865,
  -- أخرى
  ['🚜'] = 5224329198729972023,
  ['🎖'] = 5332547853304734597,
  ['🔴'] = 5812413120378838259,
  ['🔵'] = 6032841519298253772,
  ['❌'] = 5933757650276716986,
  ['🔒'] = 5296369303661067030,
  ['⚙️'] = 5366231924597604153,
  ['🔫'] = 5296383305254459545,
  ['🔬'] = 5379679518740978720,
  ['📹'] = 5832307894225212833,
  ['🚨'] = 5812047726036129920,
}

-- حساب عدد وحدات UTF-16 لكود بوينت معين
local function cp_utf16(cp)
  return cp >= 0x10000 and 2 or 1
end

-- فك ترميز UTF-8: يعيد (codepoint, bytes_count)
local function utf8_decode(s, i)
  local b = s:byte(i)
  if not b then return nil, 0 end
  if b < 0x80 then
    return b, 1
  elseif b < 0xC0 then
    return b, 1
  elseif b < 0xE0 then
    local b2 = s:byte(i+1) or 0x80
    return ((b & 0x1F) << 6) | (b2 & 0x3F), 2
  elseif b < 0xF0 then
    local b2 = s:byte(i+1) or 0x80
    local b3 = s:byte(i+2) or 0x80
    return ((b & 0x0F) << 12) | ((b2 & 0x3F) << 6) | (b3 & 0x3F), 3
  else
    local b2 = s:byte(i+1) or 0x80
    local b3 = s:byte(i+2) or 0x80
    local b4 = s:byte(i+3) or 0x80
    return ((b & 0x07) << 18) | ((b2 & 0x3F) << 12) | ((b3 & 0x3F) << 6) | (b4 & 0x3F), 4
  end
end

-- حساب طول substring بوحدات UTF-16
local function utf16_len_of(s, i, j)
  local u = 0
  local k = i
  while k <= j do
    local cp, bytes = utf8_decode(s, k)
    if not cp then break end
    u = u + cp_utf16(cp)
    k = k + bytes
  end
  return u
end

-- ترتيب أطوال المفاتيح تنازلياً (أطول أولاً لأولوية المطابقة)
local map_lengths = {}
do
  local seen = {}
  for k in pairs(M.map) do
    local n = #k
    if not seen[n] then seen[n] = true; map_lengths[#map_lengths+1] = n end
  end
  table.sort(map_lengths, function(a,b) return a > b end)
end

-- دالة المسح الداخلية - تعيد جدول entities
local function scan_entities(text, for_http)
  local entities = {}
  local i = 1
  local u16 = 0
  while i <= #text do
    local cp, bytes = utf8_decode(text, i)
    if not cp then break end
    local matched = false
    for _, len in ipairs(map_lengths) do
      if i + len - 1 <= #text then
        local candidate = text:sub(i, i + len - 1)
        local id = M.map[candidate]
        if id then
          local u16_len = utf16_len_of(text, i, i + len - 1)
          if for_http then
            entities[#entities+1] = {
              type = 'custom_emoji',
              offset = u16,
              length = u16_len,
              custom_emoji_id = tostring(id)
            }
          else
            entities[#entities+1] = {
              luatele = 'textEntity',
              offset = u16,
              length = u16_len,
              type = {
                luatele = 'textEntityTypeCustomEmoji',
                custom_emoji_id = id
              }
            }
          end
          u16 = u16 + u16_len
          i = i + len
          matched = true
          break
        end
      end
    end
    if not matched then
      u16 = u16 + cp_utf16(cp)
      i = i + bytes
    end
  end
  return entities
end

-- ترتيب entities تصاعدياً بالـ offset (مطلوب من TDLib)
local function sort_entities(ents)
  table.sort(ents, function(a, b) return a.offset < b.offset end)
  return ents
end

-- حقن entities في formattedText لـ TDLib
function M.inject(fmt)
  if type(fmt) ~= 'table' or type(fmt.text) ~= 'string' then return fmt end
  local new_ents = scan_entities(fmt.text, false)
  if #new_ents == 0 then return fmt end
  local all = {}
  if type(fmt.entities) == 'table' then
    for _, e in ipairs(fmt.entities) do all[#all+1] = e end
  end
  for _, e in ipairs(new_ents) do all[#all+1] = e end
  sort_entities(all)
  return { luatele = 'formattedText', text = fmt.text, entities = all }
end

-- بناء formattedText جديد بدون parse_mode (للنصوص العادية)
-- يعيد nil لو مفيش custom emoji (يترك الكود الأصلي يعمل)
function M.plain_fmt(text)
  local ents = scan_entities(text, false)
  if #ents == 0 then return nil end
  return { luatele = 'formattedText', text = text, entities = ents }
end

-- بناء entities لـ HTTP Bot API (JSON)
function M.http_entities(text)
  return scan_entities(text, true)
end

-- خريطة تحويل أنواع TDLib إلى أنواع HTTP Bot API
local tdlib_to_http_type = {
  textEntityTypeBold            = 'bold',
  textEntityTypeItalic          = 'italic',
  textEntityTypeCode            = 'code',
  textEntityTypePre             = 'pre',
  textEntityTypeUnderline       = 'underline',
  textEntityTypeStrikethrough   = 'strikethrough',
  textEntityTypeSpoiler         = 'spoiler',
  textEntityTypeBlockQuote      = 'blockquote',
  textEntityTypeExpandableBlockQuote = 'expandable_blockquote',
  textEntityTypeTextUrl         = 'text_link',
  textEntityTypeMentionName     = 'text_mention',
  textEntityTypeCustomEmoji     = 'custom_emoji',
  textEntityTypeMention         = 'mention',
  textEntityTypeHashtag         = 'hashtag',
  textEntityTypeUrl             = 'url',
  textEntityTypeEmailAddress    = 'email',
  textEntityTypePhoneNumber     = 'phone_number',
  textEntityTypeBotCommand      = 'bot_command',
}

-- تحويل formattedText (TDLib) + custom emoji إلى (plain_text, http_entities)
-- يُستخدم في مسار HTTP عند وجود parse_mode + custom emoji
-- يُعيد: plain_text (string), entities (table) أو nil إذا فشل
function M.fmt_to_http_entities(fmt)
  if type(fmt) ~= 'table' or type(fmt.text) ~= 'string' then return nil, nil end
  local http_ents = {}
  if type(fmt.entities) == 'table' then
    for _, e in ipairs(fmt.entities) do
      local etype = type(e.type) == 'table' and e.type or {}
      local tname = etype.luatele or etype['@type'] or etype['_']
      local htype = tname and tdlib_to_http_type[tname]
      if htype then
        local ent = { type = htype, offset = e.offset, length = e.length }
        if htype == 'text_link' then
          ent.url = etype.url or ''
        elseif htype == 'text_mention' then
          ent.user = { id = etype.user_id }
        elseif htype == 'custom_emoji' then
          ent.custom_emoji_id = tostring(etype.custom_emoji_id or 0)
        elseif htype == 'pre' and etype.language then
          ent.language = etype.language
        end
        http_ents[#http_ents+1] = ent
      end
    end
  end
  local ce_ents = scan_entities(fmt.text, true)
  for _, e in ipairs(ce_ents) do http_ents[#http_ents+1] = e end
  table.sort(http_ents, function(a,b) return a.offset < b.offset end)
  return fmt.text, http_ents
end

-- هل يحتوي النص على إيموجيات من الخريطة؟
function M.has_emoji(text)
  if type(text) ~= 'string' then return false end
  for _, len in ipairs(map_lengths) do
    local i = 1
    while i <= #text - len + 1 do
      if M.map[text:sub(i, i+len-1)] then return true end
      i = i + 1
    end
  end
  return false
end

return M
