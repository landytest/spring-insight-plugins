/**
 * Copyright (c) 2009-2011 VMware, Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.springsource.insight.plugin.neo4j;

import org.aspectj.lang.JoinPoint;

import org.springframework.data.neo4j.support.Neo4jTemplate;
import com.springsource.insight.collection.AbstractOperationCollectionAspect;
import com.springsource.insight.intercept.operation.Operation;

/**
 * This aspect create insight operation for Neo4J Template findAll/findOne()
 */
public privileged aspect FindOperationCollectionAspect extends AbstractOperationCollectionAspect {
    public FindOperationCollectionAspect() {
        super();
    }

    public pointcut collectionPoint() : execution(* Neo4jTemplate+.find*(.., Class));

	@Override
    protected Operation createOperation(JoinPoint jp) {
    	Object[] args = jp.getArgs();
        Operation op=new Operation()
        				.type(OperationCollectionTypes.FIND_TYPE.type)
        				.label(OperationCollectionTypes.FIND_TYPE.label+jp.getSignature().getName())
        				.sourceCodeLocation(getSourceCodeLocation(jp))
        				.put("entityClass", ((Class<?>)args[args.length-1]).getName());
        
        if (args.length==2) {
        	op.put("entityId", ((Number)args[0]).longValue());
        }
        
        return op;
    }

    @Override
    public String getPluginName() {
        return Neo4jPluginRuntimeDescriptor.PLUGIN_NAME;
    }
}
