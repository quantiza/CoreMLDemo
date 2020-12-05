import UIKit
import NaturalLanguage

/*:
 reference:
 - https://nshipster.com/nllanguagerecognizer/
 - https://developer.apple.com/documentation/naturallanguage/nllanguagerecognizer?changes=_6__8
 - https://blog.csdn.net/weixin_39502247/article/details/83345508
 - https://www.raywenderlich.com/books/machine-learning-by-tutorials/v2.0/chapters/14-natural-language-classification#toc-chapter-017-anchor-003
 - https://easyai.tech/ai-definition/stemming-lemmatisation/
 */
/*:
 > 1. Language identification（语言识别）, automatically detecting the language of a piece of text.
 > 2. Tokenization（词语切分）, breaking up a piece of text into linguistic units or tokens.
 > 3. Parts-of-speech tagging（词性标记）, marking up individual words with their part of speech.
 > 4. Lemmatization, deducing a word's stem based on its morphological analysis.（词干提取和词形还原）
 > 5. 识别文段中的人物，地点，和组织
 */

/*:
 基础知识：
 - Tokenization:
    * "Artificial intelligence is all about applying mathematics"
    * [“Artificial”, “intelligence”, “is”, “all”, “about”,“applying”, “mathematics”]
 
 - Tag: 为每个切分的单元打标签
 */

//: 1. 语言识别
let text1 = """
私はガラスを食べられます。
"""

let text2 = """
白日依山尽。
"""

let recognizer1 = NLLanguageRecognizer()
recognizer1.processString(text1)
recognizer1.dominantLanguage
let recognizer2 = NLLanguageRecognizer()
recognizer2.processString(text2)
recognizer2.dominantLanguage

/*: 2. 词语切分
 token unit
- case word = 0
- case sentence = 1
- case paragraph = 2
- case document = 3
*/
let text3 = """
白日依山尽。黄河入海流。
"""

let tokenizer = NLTokenizer(unit: .sentence)

tokenizer.string = text3

tokenizer.enumerateTokens(in: text3.startIndex..<text3.endIndex) { tokenRange, _ in
    print(text3[tokenRange])
    return true
}

/*: 3. 词性标记
 - NLTagTheme: tokenType, lexicalClass, nameType ....
 - NLTag: NLTagSchemeLexicalClass, NLTagSchemeNameType
*/
let text4 = "小明去上学"
let tagger = NLTagger(tagSchemes: [.lexicalClass])
tagger.string = text4
let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
tagger.enumerateTags(in: text4.startIndex..<text4.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
    if let tag = tag {
        print("\(text4[tokenRange]): \(tag.rawValue)")
    }
    return true
}

/*: 4. 词干提取和词形还原
 - plays, played, playing -> play
 - is, are, been -> be
 - 英文模糊搜索
*/

//: 5. 识别文段中的人物，地点，和组织
let text5 = "Google and Apple are in Silicon Valley near Los Angeles, President Donald Trump and I both like Google and dislike Apple."
let tagger2 = NLTagger(tagSchemes: [.nameType])
tagger2.string = text5
let options2: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
let tags: [NLTag] = [.personalName, .placeName, .organizationName]
tagger2.enumerateTags(in: text5.startIndex..<text5.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
    if let tag = tag, tags.contains(tag) {
        print("\(text5[tokenRange]): \(tag.rawValue)")
    }
    return true
}
