/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.sys.utils;

import java.util.List;
import java.util.Map;

import com.hzc.aams.common.mapper.JsonMapper;
import com.hzc.aams.common.utils.CacheUtils;
import com.hzc.aams.common.utils.SpringContextHolder;
import com.hzc.aams.modules.sys.dao.DictDao;
import com.hzc.aams.modules.sys.entity.Dict;
import org.apache.commons.lang3.StringUtils;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

/**
 * 字典工具类
 *
 * @author ThinkGem
 * @version 2013-5-29
 */
public class DictUtils {

    private static DictDao dictDao = SpringContextHolder.getBean(DictDao.class);

    public static final String CACHE_DICT_MAP = "dictMap";


    public static Dict getDict(String value, String type) {
        if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(value)) {
            for (Dict dict : getDictList(type)) {
                if (type.equals(dict.getType()) && value.equals(dict.getValue())) {
                    return dict;
                }
            }
        }
        return new Dict();
    }

    public static String getDictLabel(String value, String type, String defaultValue) {
        if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(value)) {
            for (Dict dict : getDictList(type)) {
                if (type.equals(dict.getType()) && value.equals(dict.getValue())) {
                    return dict.getLabel();
                }
            }
        }
        return defaultValue;
    }

    public static String getDictLabels(String values, String type, String defaultValue) {
        if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(values)) {
            List<String> valueList = Lists.newArrayList();
            for (String value : StringUtils.split(values, ",")) {
                valueList.add(getDictLabel(value, type, defaultValue));
            }
            return StringUtils.join(valueList, ",");
        }
        return defaultValue;
    }

    public static String getDictValue(String label, String type, String defaultLabel) {
        if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(label)) {
            for (Dict dict : getDictList(type)) {
                if (type.equals(dict.getType()) && label.equals(dict.getLabel())) {
                    return dict.getValue();
                }
            }
        }
        return defaultLabel;
    }

    public static List<Dict> getDictList(String type) {
        @SuppressWarnings("unchecked")

        Object obj = CacheUtils.get(CACHE_DICT_MAP);

        Map<String, List<Dict>> dictMap = (Map<String, List<Dict>>) obj;
        if (dictMap == null) {
            dictMap = Maps.newHashMap();
            for (Dict dict : dictDao.findAllList(new Dict())) {
                List<Dict> dictList = dictMap.get(dict.getType());
                if (dictList != null) {
                    dictList.add(dict);
                } else {
                    dictMap.put(dict.getType(), Lists.newArrayList(dict));
                }
            }
            CacheUtils.put(CACHE_DICT_MAP, dictMap);
        }
        List<Dict> dictList = dictMap.get(type);
        if (dictList == null) {
            dictList = Lists.newArrayList();
        }
        return dictList;
    }

    /**
     * 返回字典列表（JSON）
     *
     * @param type
     * @return
     */
    public static String getDictListJson(String type) {
        return JsonMapper.toJsonString(getDictList(type));
    }

}
