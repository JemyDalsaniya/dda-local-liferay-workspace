package rest.builder.example.client.function;

import javax.annotation.Generated;

/**
 * @author root321
 * @generated
 */
@FunctionalInterface
@Generated("")
public interface UnsafeSupplier<T, E extends Throwable> {

	public T get() throws E;

}