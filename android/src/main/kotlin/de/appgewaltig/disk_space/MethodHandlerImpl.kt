package de.appgewaltig.disk_space

import android.os.Environment
import android.os.StatFs
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.math.ceil

class MethodHandlerImpl : MethodChannel.MethodCallHandler {
    var totalDiskSpace = 0
    var freeDiskSpace = 0
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "getFreeDiskSpace" -> result.success(getFreeDiskSpace())
            "getTotalDiskSpace" -> result.success(getTotalDiskSpace())
            "getUsedDiskSpace" -> result.success(getUsedDiskSpace())
            "getPercentageUsedDiskSpace" -> result.success(getPercentageUsedDiskSpace())
            "getFreeDiskSpaceForPath" -> result.success(getFreeDiskSpaceForPath(call.argument<String>("path")!!))
            else -> result.notImplemented()
        }
    }

    private fun getFreeDiskSpaceGB(): Int {
        val stat = StatFs(Environment.getExternalStorageDirectory().path)

        val bytesAvailable: Long
        bytesAvailable = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
            stat.blockSizeLong * stat.availableBlocksLong
        else
            stat.blockSize.toLong() * stat.availableBlocks.toLong()
        return ceil((bytesAvailable / (1024f * 1024f * 1024f))).toInt()
    }

    private fun getFreeDiskSpace(): String {
        freeDiskSpace = getFreeDiskSpaceGB()
        return freeDiskSpace.toString()
    }

    private fun getFreeDiskSpaceForPath(path: String): String {
        val stat = StatFs(path)
    
        val bytesAvailable: Long
        bytesAvailable = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
            stat.blockSizeLong * stat.availableBlocksLong
        else
            stat.blockSize.toLong() * stat.availableBlocks.toLong()
        return (bytesAvailable / (1024f * 1024f)).toString()
    }

    private fun getTotalDiskSpaceGB(): Int {
        val stat = StatFs(Environment.getExternalStorageDirectory().path)

        val bytesAvailable: Long
        bytesAvailable = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
            stat.blockSizeLong * stat.blockCountLong
        else
            stat.blockSize.toLong() * stat.blockCount.toLong()

        return ceil((bytesAvailable / (1024f * 1024f * 1024f))).toInt()
    }

    private fun getTotalDiskSpace(): String {
        totalDiskSpace = getTotalDiskSpaceGB()
        return totalDiskSpace.toString()
    }

    private fun getUsedDiskSpace(): String {
        return (totalDiskSpace - freeDiskSpace).toString()
    }

    private fun getPercentageUsedDiskSpace(): String {
        val used = totalDiskSpace.toFloat() - freeDiskSpace.toFloat()
        val percent = ((used / totalDiskSpace.toFloat()) * 100)
        return String.format("%.0f", percent)
    }
}