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
