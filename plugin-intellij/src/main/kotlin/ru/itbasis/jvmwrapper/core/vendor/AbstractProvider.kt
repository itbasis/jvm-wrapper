package ru.itbasis.jvmwrapper.core.vendor

import com.intellij.openapi.util.SystemInfo.is32Bit
import com.intellij.openapi.util.SystemInfo.isMac
import com.intellij.openapi.util.SystemInfo.isWindows
import org.apache.http.HttpResponse
import org.apache.http.client.CookieStore
import org.apache.http.client.methods.HttpGet
import org.apache.http.client.protocol.HttpClientContext.COOKIE_STORE
import org.apache.http.impl.client.BasicCookieStore
import org.apache.http.impl.client.CloseableHttpClient
import org.apache.http.impl.client.HttpClients
import org.apache.http.impl.client.LaxRedirectStrategy
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager
import org.apache.http.protocol.BasicHttpContext
import org.apache.http.protocol.HttpContext
import org.apache.http.util.EntityUtils
import ru.itbasis.jvmwrapper.core.RemoteArchiveFile
import java.io.File

typealias DownloadProcessListener = (remoteArchiveFile: RemoteArchiveFile, sizeCurrent: Long, sizeTotal: Long) -> Boolean

abstract class AbstractProvider {
  abstract val remoteArchiveFile: RemoteArchiveFile?

  fun download(target: File, downloadProcessListener: DownloadProcessListener? = null) =
    download(remoteArchiveFile!!, target, downloadProcessListener)

  abstract fun download(remoteArchiveFile: RemoteArchiveFile, target: File, downloadProcessListener: DownloadProcessListener? = null)

  open fun RemoteArchiveFile.isRequireAuthentication() = false

  abstract fun String?.getRemoteArchiveFile(): RemoteArchiveFile?

  open fun String.urlWithinHost() = this

  val archiveArchitecture = if (is32Bit) "i586" else "x64"

  val archiveExtension = when {
    isMac -> "dmg"
    isWindows -> "exe"
    else -> "tar.gz"
  }

  protected val httpCookieStore: CookieStore = BasicCookieStore()
  protected val httpContext: HttpContext = BasicHttpContext().also {
    it.setAttribute(COOKIE_STORE, httpCookieStore)
  }

  protected val httpClient: CloseableHttpClient = HttpClients.custom()
    .setUserAgent("Mozilla/5.0 https://github.com/itbasis/jvm-wrapper")
    .setConnectionManager(PoolingHttpClientConnectionManager())
    .setRedirectStrategy(LaxRedirectStrategy())
    .build()!!

  protected fun String.htmlContent() = httpClient.execute(HttpGet(urlWithinHost()), httpContext).content()

  private fun HttpResponse.content(): String = EntityUtils.toString(entity)

  protected fun Regex.getOneResult(content: String) = findAll(content).onlyOne()?.groupValues?.get(1)

  protected fun Sequence<MatchResult>.onlyOne(): MatchResult? = when (count()) {
    0 -> null
    1 -> this.first()
    else -> throw IllegalStateException("found over one results: ${count()}")
  }
}
