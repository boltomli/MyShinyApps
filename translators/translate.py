import translators as ts

providers = {
    'alibaba': ts.alibaba,
    'baidu': ts.baidu,
    'bing': ts.bing,
    'deepl': ts.deepl,
    'google': ts.google,
    'sogou': ts.sogou,
    'tencent': ts.tencent,
    'youdao': ts.youdao,
}


def list_providers():
    return list(providers.keys())


def translate(text, provider, use_cn_host=True, from_language='en', to_language='zh'):
    try:
        result = providers[provider](text, from_language=from_language, to_language=to_language, if_use_cn_host=use_cn_host)
    except:
        result = provider + " no result"
    return result
